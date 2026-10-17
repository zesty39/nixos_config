#!/usr/bin/env bash
set -euo pipefail

# --- HELP BEGIN ---
# Usage:
#   scripts/remote-run.sh [--sudo] <command> [args...]
#
# Environment:
#   REMOTE_MACHINE   Remote SSH target, for example <user>@<host>
#   REMOTE_PASSWORD  SSH password, also used for sudo when --sudo is set
#
# The script loads .env from the repository root before reading the variables.
#
# Example (remote checkout path supplied by the operator):
#   scripts/remote-run.sh --sudo "nixos-rebuild build --flake /path/to/hmconfig#xps13"
# --- HELP END ---

# Variables
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

readonly SCRIPT_DIR
readonly SCRIPT_NAME

ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

readonly ROOT_DIR
USE_SUDO=0
SSH_ARGS=(
  -F /dev/null
  -o StrictHostKeyChecking=accept-new
  -o PreferredAuthentications=password
  -o PubkeyAuthentication=no
)

readonly SSH_ARGS


# Functions
error() {
  printf '[ERROR]: %s\n' "$*" >&2
  exit 2
}

print_usage() {
  sed -n \
    -e '/^# --- HELP BEGIN ---$/,/^# --- HELP END ---$/!d' \
    -e '/^# --- HELP BEGIN ---$/d' \
    -e '/^# --- HELP END ---$/d' \
    -e 's/^# //' \
    -e 's/^#$//' \
    -e 'p' \
    "$SCRIPT_DIR/$SCRIPT_NAME"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || error "missing required command: $1"
}

shell_quote() {
  local value="$1"
  value="${value//\'/\'\\\'\'}"
  printf "'%s'" "$value"
}

remote_command() {
  local command
  local arg
  local quoted_arg

  if [[ $# -eq 1 ]]; then
    printf '%s' "$1"
    return
  fi

  command=""
  for arg in "$@"; do
    quoted_arg="$(shell_quote "$arg")"
    if [[ -n "$command" ]]; then
      command+=" "
    fi
    command+="$quoted_arg"
  done

  printf '%s' "$command"
}

remote_sudo_command() {
  local command

  command="$(remote_command "$@")"
  command="sudo -S -p '' -- sh -c $(shell_quote "$command")"

  printf '%s\n' "$REMOTE_PASSWORD" | sshpass -e ssh "${SSH_ARGS[@]}" "$REMOTE_MACHINE" "$command"
}

run_remote_command() {
  local command

  command="$(remote_command "$@")"

  if [[ "$USE_SUDO" -eq 1 ]]; then
    remote_sudo_command "$@"
  else
    sshpass -e ssh "${SSH_ARGS[@]}" "$REMOTE_MACHINE" "$command"
  fi
}

# Main
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  print_usage
  exit 0
fi

if [[ "${1:-}" == "--sudo" ]]; then
  USE_SUDO=1
  shift
fi

if [[ "${1:-}" == -* ]]; then
  error "unknown option: $1"
fi

if [[ $# -eq 0 ]]; then
  print_usage >&2
  exit 2
fi

if [[ -f "$ROOT_DIR/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
  set +a
fi

require_command sshpass
require_command ssh

[[ -n "${REMOTE_MACHINE:-}" ]] || error "REMOTE_MACHINE is required"
[[ -n "${REMOTE_PASSWORD:-}" ]] || error "REMOTE_PASSWORD is required"

export SSHPASS="$REMOTE_PASSWORD"

run_remote_command "$@"
