#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="${BASE_DIR}/packages"

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
Usage: ./build.sh [component|all]

Components: ${COMPONENT_LIST}
Example:    ./build.sh python
            ./build.sh all
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "✗ Missing command: ${cmd}"
    exit 1
  fi
}

run_in_dir() {
  local dir="$1"
  shift
  pushd "${dir}" >/dev/null
  "$@"
  local status=$?
  popd >/dev/null
  return ${status}
}

build_python() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[python]}"
  require_cmd python
  echo "→ Building Python SDK"
  run_in_dir "${dir}" python -m pip install --upgrade pip
  run_in_dir "${dir}" python -m pip install build pytest pytest-cov >/dev/null
  run_in_dir "${dir}" python -m pytest
  run_in_dir "${dir}" python -m build
}

build_php() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[php]}"
  require_cmd composer
  echo "→ Building PHP SDK"
  run_in_dir "${dir}" composer install
  run_in_dir "${dir}" composer test
}

build_node_package() {
  local dir="$1"
  require_cmd npm
  run_in_dir "${dir}" npm install --package-lock=false --ignore-workspace-root-check
  run_in_dir "${dir}" npm run build --if-present
  run_in_dir "${dir}" npm run test --if-present || true
}

build_node() {
  echo "→ Building Node SDK"
  build_node_package "${PACKAGES_DIR}/${REPO_NAMES[node]}"
}

build_mock_server() {
  echo "→ Building Mock Server"
  build_node_package "${PACKAGES_DIR}/${REPO_NAMES[mock-server]}"
}

build_test_utils() {
  echo "→ Building Test Utils"
  build_node_package "${PACKAGES_DIR}/${REPO_NAMES[test-utils]}"
}

build_flutter() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[flutter]}"
  require_cmd flutter
  echo "→ Building Flutter/Dart SDK"
  run_in_dir "${dir}" flutter pub get
  run_in_dir "${dir}" flutter test
}

build_go_sdk() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[go]}"
  require_cmd go
  echo "→ Building Go SDK"
  run_in_dir "${dir}" go test ./...
  run_in_dir "${dir}" go build ./...
}

build_cli() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[cli]}"
  require_cmd go
  echo "→ Building Go CLI"
  run_in_dir "${dir}" go test ./...
  run_in_dir "${dir}" go build ./...
}

build_component() {
  local component="$1"
  case "${component}" in
    python) build_python ;;
    php) build_php ;;
    node) build_node ;;
    flutter) build_flutter ;;
    go) build_go_sdk ;;
    cli) build_cli ;;
    mock-server) build_mock_server ;;
    test-utils) build_test_utils ;;
    *) echo "Unknown component: ${component}" && exit 1 ;;
  esac
}

main() {
  if [[ $# -lt 1 ]]; then
    usage
    exit 1
  fi

  local target="$1"

  if [[ "${target}" == "all" ]]; then
    for component in "${!REPO_NAMES[@]}"; do
      build_component "${component}"
    done
  else
    build_component "${target}"
  fi
}

main "$@"
