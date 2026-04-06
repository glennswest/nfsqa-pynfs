#!/bin/bash
# ci-rpm.sh — Build nfsqa-pynfs RPM on Fedora runner
set -euo pipefail

SRC="${1:-/build}"
cd "$SRC"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       nfsqa-pynfs RPM Builder                               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo "  Host:   $(hostname)"
echo "  Date:   $(date)"
echo "  Arch:   $(uname -m)"
echo "  Kernel: $(uname -r)"
echo ""

# ── Install build deps ─────────────────────────────────────────────
echo "==> Installing build dependencies..."
dnf install -y rpm-build python3-devel python3-ply python3-gssapi \
    swig krb5-devel gcc git 2>&1 | tail -1

# ── Clone upstream ─────────────────────────────────────────────────
echo "==> Cloning pynfs upstream..."
TMPDIR=$(mktemp -d)
PKG="nfsqa-pynfs"
VERSION="1.0.0"
git clone --depth 1 https://github.com/kofemann/pynfs.git "$TMPDIR/$PKG-$VERSION"

# Copy wrapper script into source
mkdir -p "$TMPDIR/$PKG-$VERSION/bin"
cp "$SRC/bin/nfsqa-pynfs-run" "$TMPDIR/$PKG-$VERSION/bin/"

# ── Build RPM ──────────────────────────────────────────────────────
echo "==> Building RPM..."
RPMBUILD="$SRC/dist/rpmbuild"
mkdir -p "$RPMBUILD"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

tar -C "$TMPDIR" -czf "$RPMBUILD/SOURCES/$PKG-$VERSION.tar.gz" "$PKG-$VERSION"
cp "$SRC/nfsqa-pynfs.spec" "$RPMBUILD/SPECS/"

rpmbuild --define "_topdir $RPMBUILD" -bb "$RPMBUILD/SPECS/nfsqa-pynfs.spec"

# ── Collect output ─────────────────────────────────────────────────
mkdir -p "$SRC/dist"
find "$RPMBUILD/RPMS" -name "*.rpm" -exec cp {} "$SRC/dist/" \;
rm -rf "$TMPDIR"

echo ""
echo "==> Done. RPMs:"
ls -lh "$SRC/dist/"*.rpm
