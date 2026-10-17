#!/usr/bin/env bash
set -euo pipefail

# --- HELP BEGIN ---
# Usage:
#   mihomo-gen-config [options]
#
# Options:
#   --provider NAME=URL              Provider pair. Can be passed multiple times.
#   --default-provider NAME|provider-N
#                                    Default provider name or provider-<number>.
#   --template PATH                  Config template path.
#   -o, --output PATH                Generated config output path.
#   --stdout                         Write generated config to stdout.
#   -h, --help                       Show this help.
# --- HELP END ---

# Variables
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

readonly SCRIPT_DIR
readonly SCRIPT_NAME

shopt -u patsub_replacement 2>/dev/null || true

DEFAULT_TEMPLATE="/etc/mihomo/template.yaml"
DEFAULT_OUTPUT="/etc/mihomo/config.yaml"

readonly DEFAULT_TEMPLATE
readonly DEFAULT_OUTPUT

TEMPLATE="$DEFAULT_TEMPLATE"
OUTPUT="$DEFAULT_OUTPUT"
WRITE_STDOUT=0
PROVIDER_ARGS=()
DEFAULT_PROVIDER=""

NAMES=()
URLS=()
PROVIDER_ENTRIES=""
PROVIDER_ANCHORS=""
PROVIDER_GROUP_NAMES=""
PROVIDER_GROUPS=""

# Functions
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

error() {
  printf '[ERROR]: %s\n' "$*" >&2
  exit 2
}

yaml_quote() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '"%s"' "$value"
}

add_provider() {
  local name="$1"
  local url="$2"
  local existing_name

  [[ -n "$name" ]] || error "provider name must not be empty"
  [[ -n "$url" ]] || error "provider URL must not be empty"

  for existing_name in "${NAMES[@]}"; do
    [[ "$existing_name" != "$name" ]] || error "duplicate provider name: $name"
  done

  NAMES+=("$name")
  URLS+=("$url")
}

parse_provider_arg() {
  local value="$1"
  local name
  local url

  [[ "$value" == *=* ]] || error "invalid --provider value: $value"
  name="${value%%=*}"
  url="${value#*=}"
  add_provider "$name" "$url"
}

resolve_default_provider_name() {
  local index
  local name

  [[ -n "$DEFAULT_PROVIDER" ]] || error "--default-provider must be set"

  if [[ "$DEFAULT_PROVIDER" =~ ^provider-([0-9]+)$ ]]; then
    index="${BASH_REMATCH[1]}"
    (( index >= 1 && index <= ${#NAMES[@]} )) || error "--default-provider does not exist: $DEFAULT_PROVIDER"
    printf '%s' "${NAMES[$((index - 1))]}"
    return
  fi

  for name in "${NAMES[@]}"; do
    if [[ "$name" == "$DEFAULT_PROVIDER" ]]; then
      printf '%s' "$name"
      return
    fi
  done

  error "--default-provider does not exist: $DEFAULT_PROVIDER"
}

build_render_values() {
  local default_provider_name="$1"
  local i
  local provider_number
  local provider_group_name

  PROVIDER_ENTRIES=""
  PROVIDER_ANCHORS=""
  PROVIDER_GROUP_NAMES=""
  PROVIDER_GROUPS=""

  for i in "${!NAMES[@]}"; do
    provider_number=$((i + 1))
    provider_group_name="provider-${provider_number}"

    PROVIDER_ENTRIES+="  $(yaml_quote "${NAMES[$i]}"):"$'\n'
    PROVIDER_ENTRIES+="    <<: *providers"$'\n'
    PROVIDER_ENTRIES+="    url: $(yaml_quote "${URLS[$i]}")"$'\n'

    PROVIDER_ANCHORS+="${provider_group_name}: &${provider_group_name} { use: [$(yaml_quote "${NAMES[$i]}")] }"$'\n'

    if [[ -n "$PROVIDER_GROUP_NAMES" ]]; then
      PROVIDER_GROUP_NAMES+=", "
    fi
    PROVIDER_GROUP_NAMES+="$provider_group_name"

    PROVIDER_GROUPS+="  - {"$'\n'
    PROVIDER_GROUPS+="      name: ${provider_group_name},"$'\n'
    PROVIDER_GROUPS+="      type: select,"$'\n'
    PROVIDER_GROUPS+="      icon: \"https://raw.githubusercontent.com/echs-top/proxy/09dca5e96bd6600520f532ba60c9d589e3f75e6c/img/icon/Network.webp\","$'\n'
    PROVIDER_GROUPS+="      <<: *${provider_group_name},"$'\n'
    PROVIDER_GROUPS+="    }"$'\n'
  done

  PROVIDER_ANCHORS+="provider-default: &provider-default { use: [$(yaml_quote "$default_provider_name")] }"
}

render_config() {
  local default_provider_name
  local config

  [[ -f "$TEMPLATE" ]] || error "missing template: $TEMPLATE"
  [[ ${#NAMES[@]} -gt 0 ]] || error "no providers configured; pass --provider NAME=URL"

  if ! default_provider_name="$(resolve_default_provider_name)"; then
    exit 1
  fi
  build_render_values "$default_provider_name"

  config="$(<"$TEMPLATE")"
  config="${config//@PROVIDER_ENTRIES@/$PROVIDER_ENTRIES}"
  config="${config//@PROVIDER_ANCHORS@/$PROVIDER_ANCHORS}"
  config="${config//@PROVIDER_GROUP_NAMES@/$PROVIDER_GROUP_NAMES}"
  config="${config//@PROVIDER_GROUPS@/$PROVIDER_GROUPS}"
  config="${config//@DEFAULT_PROVIDER_ANCHOR@/provider-default}"

  printf '%s' "$config"
}

# Main

while [[ $# -gt 0 ]]; do
  case "$1" in
    --provider)
      [[ $# -ge 2 ]] || error "--provider requires NAME=URL"
      PROVIDER_ARGS+=("$2")
      shift 2
      ;;
    --provider=*)
      PROVIDER_ARGS+=("${1#--provider=}")
      shift
      ;;
    --default-provider)
      [[ $# -ge 2 ]] || error "--default-provider requires NAME or provider-N"
      DEFAULT_PROVIDER="$2"
      shift 2
      ;;
    --default-provider=*)
      DEFAULT_PROVIDER="${1#--default-provider=}"
      shift
      ;;
    --template)
      [[ $# -ge 2 ]] || error "--template requires PATH"
      TEMPLATE="$2"
      shift 2
      ;;
    --template=*)
      TEMPLATE="${1#--template=}"
      shift
      ;;
    -o|--output)
      [[ $# -ge 2 ]] || error "$1 requires PATH"
      OUTPUT="$2"
      shift 2
      ;;
    --output=*)
      OUTPUT="${1#--output=}"
      shift
      ;;
    --stdout)
      WRITE_STDOUT=1
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      error "unknown argument: $1"
      ;;
  esac
done

for PROVIDER_ARG in "${PROVIDER_ARGS[@]}"; do
  parse_provider_arg "$PROVIDER_ARG"
done

RENDERED="$(render_config)"

if [[ "$WRITE_STDOUT" -eq 1 ]]; then
  printf '%s' "$RENDERED"
  exit 0
fi

OUTPUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUTPUT_DIR"
umask 007
OUTPUT_TMP="$(mktemp "${OUTPUT_DIR}/.config.yaml.XXXXXX")"
printf '%s' "$RENDERED" > "$OUTPUT_TMP"
chmod 660 "$OUTPUT_TMP"
if ! mihomo -t -f "$OUTPUT_TMP" >/dev/null; then
  rm -f "$OUTPUT_TMP"
  error "generated config failed validation"
fi
mv "$OUTPUT_TMP" "$OUTPUT"
