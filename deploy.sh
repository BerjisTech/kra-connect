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
Usage: ./deploy.sh [component|all]

Components: ${COMPONENT_LIST}
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

deploy_python() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[python]}"
  require_cmd python
  require_cmd twine
  echo "→ Publishing Python SDK to PyPI"
  run_in_dir "${dir}" python -m build
  run_in_dir "${dir}" python -m twine upload dist/*
}

deploy_php() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[php]}"
  echo "→ PHP SDK deploy"
  echo "   Packagist updates automatically when you push a version tag."
  echo "   Ensure you've run: git -C ${dir} tag vX.Y.Z && git -C ${dir} push origin --tags"
}

deploy_node_pkg() {
  local dir="$1"
  require_cmd npm
  run_in_dir "${dir}" npm publish --access public
}

deploy_node() {
  echo "→ Publishing Node SDK to npm"
  deploy_node_pkg "${PACKAGES_DIR}/${REPO_NAMES[node]}"
}

deploy_mock_server() {
  echo "→ Publishing Mock Server package to npm"
  deploy_node_pkg "${PACKAGES_DIR}/${REPO_NAMES[mock-server]}"
}

deploy_test_utils() {
  echo "→ Publishing Test Utils package to npm"
  deploy_node_pkg "${PACKAGES_DIR}/${REPO_NAMES[test-utils]}"
}

deploy_flutter() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[flutter]}"
  require_cmd dart
  echo "→ Publishing Flutter/Dart SDK to pub.dev"
  run_in_dir "${dir}" dart pub publish
}

deploy_go_sdk() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[go]}"
  echo "→ Go modules are distributed via git tags."
  echo "   Run: git -C ${dir} tag vX.Y.Z && git -C ${dir} push origin --tags"
}

deploy_cli() {
  local dir="${PACKAGES_DIR}/${REPO_NAMES[cli]}"
  if command -v goreleaser >/dev/null 2>&1; then
    echo "→ Running GoReleaser for CLI"
    run_in_dir "${dir}" goreleaser release --clean
  else
    echo "→ goreleaser not found; please install it or publish manually."
  fi
}

deploy_component() {
  local component="$1"
  case "${component}" in
    python) deploy_python ;;
    php) deploy_php ;;
    node) deploy_node ;;
    flutter) deploy_flutter ;;
    go) deploy_go_sdk ;;
    cli) deploy_cli ;;
    mock-server) deploy_mock_server ;;
    test-utils) deploy_test_utils ;;
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
      deploy_component "${component}"
    done
  else
    deploy_component "${target}"
  fi
}

main "$@"
