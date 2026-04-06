#!/bin/bash
set -euo pipefail

UPSTREAM_REPO="https://github.com/kofemann/pynfs.git"
PKG_NAME="nfsqa-pynfs"
VERSION="1.0.0"
RPMBUILD_DIR="$HOME/rpmbuild"

echo "==> Setting up rpmbuild tree..."
mkdir -p "$RPMBUILD_DIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "==> Cloning pynfs upstream..."
TMPDIR="$(mktemp -d)"
git clone --depth 1 "$UPSTREAM_REPO" "$TMPDIR/$PKG_NAME-$VERSION"

echo "==> Copying packaging files..."
mkdir -p "$TMPDIR/$PKG_NAME-$VERSION/bin"
cp bin/nfsqa-pynfs-run "$TMPDIR/$PKG_NAME-$VERSION/bin/"

echo "==> Creating source tarball..."
tar -C "$TMPDIR" -czf "$RPMBUILD_DIR/SOURCES/$PKG_NAME-$VERSION.tar.gz" "$PKG_NAME-$VERSION"

echo "==> Copying spec file..."
cp nfsqa-pynfs.spec "$RPMBUILD_DIR/SPECS/"

echo "==> Building RPM..."
rpmbuild -bb "$RPMBUILD_DIR/SPECS/nfsqa-pynfs.spec"

echo "==> Copying RPM to output..."
find "$RPMBUILD_DIR/RPMS" -name "${PKG_NAME}*.rpm" -exec cp {} . \;

echo "==> Cleaning up..."
rm -rf "$TMPDIR"

echo "==> Done. Packages:"
ls -la ${PKG_NAME}*.rpm 2>/dev/null || echo "(check $RPMBUILD_DIR/RPMS/)"
