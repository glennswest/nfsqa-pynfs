#!/bin/bash
set -euo pipefail

UPSTREAM_REPO="https://github.com/kofemann/pynfs.git"
UPSTREAM_REF="master"
PKG_NAME="nfsqa-pynfs"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$(mktemp -d)"

trap "rm -rf '$BUILD_DIR'" EXIT

echo "==> Cloning pynfs upstream..."
git clone --depth 1 --branch "$UPSTREAM_REF" "$UPSTREAM_REPO" "$BUILD_DIR/$PKG_NAME"

echo "==> Copying debian packaging..."
cp -a "$SCRIPT_DIR/debian" "$BUILD_DIR/$PKG_NAME/"
cp -a "$SCRIPT_DIR/bin" "$BUILD_DIR/$PKG_NAME/"

echo "==> Building .deb..."
cd "$BUILD_DIR/$PKG_NAME"
dpkg-buildpackage -us -uc -b

echo "==> Copying .deb to output..."
cp "$BUILD_DIR"/${PKG_NAME}_*.deb "$SCRIPT_DIR/"

echo "==> Done. Package:"
ls -la "$SCRIPT_DIR"/${PKG_NAME}_*.deb
