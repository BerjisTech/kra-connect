#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="${BASE_DIR}/packages"
GIT_ORG="BerjisTech"

declare -A REPO_NAMES=(
  ["python"]="kra-connect-python-sdk"
  ["php"]="kra-connect-php-sdk"
  ["node"]="kra-connect-node-sdk"
  ["flutter"]="kra-connect-flutter-sdk"
  ["go"]="kra-connect-go-sdk"
  ["cli"]="kra-cli"
  ["mock-server"]="kra-connect-mock-server"
  ["test-utils"]="kra-connect-test-utils"
)

COMPONENT_LIST=$(printf "%s " "${!REPO_NAMES[@]}")

usage() {
  cat <<EOF
Usage: ./setup.sh [component|all]

Components: ${COMPONENT_LIST}
Example:    ./setup.sh python
            ./setup.sh all
EOF
}

clone_or_update() {
  local name="$1"
  local repo="$2"
  local target_dir="${PACKAGES_DIR}/${repo}"
  local url="https://github.com/${GIT_ORG}/${repo}.git"

  mkdir -p "${PACKAGES_DIR}"

  if [[ -d "${target_dir}/.git" ]]; then
    echo "→ Updating ${name} (${repo})"
    git -C "${target_dir}" fetch --all --tags --prune
    git -C "${target_dir}" pull --ff-only
  elif [[ -d "${target_dir}" ]]; then
    echo "✗ ${target_dir} exists but is not a git repo. Skipping."
  else
    echo "→ Cloning ${name} from ${url}"
    git clone "${url}" "${target_dir}"
  fi
}

process_component() {
  local component="$1"
  local repo="${REPO_NAMES[$component]}"

  if [[ -z "${repo:-}" ]]; then
    echo "Unknown component: ${component}"
    exit 1
  fi

  clone_or_update "${component}" "${repo}"
}

main() {
  if [[ $# -lt 1 ]]; then
    usage
    exit 1
  fi

  local target="$1"

  if [[ "${target}" == "all" ]]; then
    for component in "${!REPO_NAMES[@]}"; do
      process_component "${component}"
    done
  else
    process_component "${target}"
  fi
}

main "$@"
