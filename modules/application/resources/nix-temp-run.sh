#!/usr/bin/env bash
# --- HELP BEGIN ---
# Usage:
#   nix-temp-run INSTALLABLE -- COMMAND [ARGS...]
#   nix-temp-run -h | --help
#
# Run a Nix package with a read-only host filesystem and a temporary home.
# Nix keeps its normal home and cache. Application files remain in the printed
# temporary directory after exit. Network and local Wayland remain available.
# PulseAudio is supported when its local socket is available. X11 is not exposed.
# Desktop services are restricted; this is not a complete security boundary.
# Standard streams must be terminals, anonymous pipes, or /dev/null.
# --- HELP END ---
set -euo pipefail

# Variables
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_NAME=$(basename -- "${BASH_SOURCE[0]}")
RUN_DIR=
RESOLV_CONF=
BWRAP_ARGS=()
INSTALLABLE=

readonly SCRIPT_DIR
readonly SCRIPT_NAME

# Functions
print_usage() {
  sed -n \
    -e '/^# --- HELP BEGIN ---$/,/^# --- HELP END ---$/!d' \
    -e '/^# --- HELP BEGIN ---$/d' \
    -e '/^# --- HELP END ---$/d' \
    -e 's/^# //' -e 's/^#$//' -e p \
    "$SCRIPT_DIR/$SCRIPT_NAME"
}

info() {
  printf '[INFO]: %s\n' "$*"
}

error() {
  printf '[ERROR]: %s\n' "$*" >&2
  exit 2
}

validate_standard_streams() {
  # Writable inherited files bypass read-only mounts, including standard streams.
  local fd fd_target
  for fd in 0 1 2; do
    fd_target=$(readlink "/proc/$$/fd/$fd")
    if [[ ! -t $fd && $fd_target != /dev/null && $fd_target != pipe:\[*\] ]]; then
      error "Standard stream $fd must be a terminal, anonymous pipe, or /dev/null."
    fi
  done
}

prepare_run_directory() {
  RUN_DIR=$(mktemp -d /tmp/nix-temp-run.XXXXXXXXXX)
  trap 'info "Application files retained at $RUN_DIR" >&2' EXIT
  mkdir -p "$RUN_DIR"/{home,config,data,cache,state,runtime,tmp,work}
}

configure_sandbox() {
  BWRAP_ARGS=(
    --unshare-user --unshare-pid --unshare-ipc --unshare-uts
    --new-session --die-with-parent --cap-drop ALL
    --ro-bind / / --proc /proc --dev /dev
    --tmpfs /tmp --tmpfs /run --tmpfs /var
    --tmpfs /nix/var/nix/daemon-socket
    --ro-bind /run/current-system /run/current-system
    --ro-bind "$RESOLV_CONF" "$RESOLV_CONF"
    --bind "$RUN_DIR" "$RUN_DIR"
    --chdir "$RUN_DIR/work"
    --setenv HOME "$RUN_DIR/home"
    --setenv XDG_CONFIG_HOME "$RUN_DIR/config"
    --setenv XDG_DATA_HOME "$RUN_DIR/data"
    --setenv XDG_CACHE_HOME "$RUN_DIR/cache"
    --setenv XDG_STATE_HOME "$RUN_DIR/state"
    --setenv XDG_RUNTIME_DIR "$RUN_DIR/runtime"
    --setenv TMPDIR "$RUN_DIR/tmp"
    --setenv DBUS_SESSION_BUS_ADDRESS "unix:path=$RUN_DIR/runtime/bus"
    --setenv DBUS_SYSTEM_BUS_ADDRESS "unix:path=$RUN_DIR/runtime/bus"
    --setenv AT_SPI_BUS_ADDRESS "unix:path=$RUN_DIR/runtime/bus"
  )
  local env_name
  for env_name in LANG LC_ALL LC_CTYPE TZ TERM COLORTERM; do
    if [[ -n ${!env_name:-} ]]; then
      BWRAP_ARGS+=(--setenv "$env_name" "${!env_name}")
    fi
  done
  BWRAP_ARGS+=(--setenv XDG_DATA_DIRS /run/current-system/sw/share)
}

configure_desktop() {
  local host_path wayland_socket pulse_socket
  for host_path in /run/opengl-driver /run/opengl-driver-32; do
    if [[ -d $host_path ]]; then
      BWRAP_ARGS+=(--ro-bind "$host_path" "$host_path")
    fi
  done
  if [[ -d /dev/dri ]]; then
    BWRAP_ARGS+=(--dev-bind /dev/dri /dev/dri)
  fi
  wayland_socket=${WAYLAND_DISPLAY:-wayland-0}
  if [[ $wayland_socket != /* ]]; then
    wayland_socket=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/$wayland_socket
  fi
  if [[ -S $wayland_socket ]]; then
    BWRAP_ARGS+=(
      --ro-bind "$wayland_socket" "$RUN_DIR/runtime/wayland-0"
      --setenv WAYLAND_DISPLAY wayland-0
      --setenv XDG_SESSION_TYPE wayland
      --setenv NIXOS_OZONE_WL 1
    )
  fi
  pulse_socket=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/pulse/native
  if [[ -S $pulse_socket ]]; then
    BWRAP_ARGS+=(
      --ro-bind "$pulse_socket" "$RUN_DIR/runtime/pulse-native"
      --setenv PULSE_SERVER "unix:$RUN_DIR/runtime/pulse-native"
    )
  fi
}

run_application() {
  # shellcheck disable=SC2016 # Expand PATH and descriptors inside the Nix shell.
  NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "$INSTALLABLE" --command bash -c \
    'for FD_PATH in /proc/$$/fd/*; do
      FD=${FD_PATH##*/}
      if (( FD > 2 )); then exec {FD}>&-; fi
    done
    exec bwrap --clearenv --setenv PATH "$PATH" "$@"' \
    bash "${BWRAP_ARGS[@]}" -- "$@"
}

# Main
if [[ $# == 1 && ( $1 == -h || $1 == --help ) ]]; then
  print_usage
  exit 0
fi
[[ $# -ge 3 && $1 != -* && $2 == -- && -n $3 ]] || error 'Expected INSTALLABLE -- COMMAND [ARGS...]; use --help.'
validate_standard_streams
INSTALLABLE=$1
shift 2
umask 077
RESOLV_CONF=$(realpath /etc/resolv.conf)
prepare_run_directory

readonly RESOLV_CONF
readonly INSTALLABLE
readonly RUN_DIR

configure_sandbox
configure_desktop
run_application "$@"
