Name:           nfsqa-pynfs
Version:        1.0.0
Release:        1%{?dist}
Summary:        NFSv4 protocol conformance test suite (pynfs)
License:        GPL-2.0-only
URL:            https://github.com/kofemann/pynfs
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  python3-devel
BuildRequires:  python3-ply
BuildRequires:  python3-gssapi
BuildRequires:  swig
BuildRequires:  krb5-devel
BuildRequires:  gcc
BuildRequires:  git

Requires:       python3
Requires:       python3-ply
Requires:       python3-gssapi

%description
Wire-level NFSv4.0 and NFSv4.1 protocol conformance testing.
Speaks RPC directly to port 2049 — no kernel NFS mount required.
Includes ~565 NFSv4.0 tests and ~300 NFSv4.1 tests covering all
NFS operations.

%prep
%setup -q

%build
cd nfs4.0 && python3 setup.py build_ext --inplace && cd ..
cd nfs4.1 && python3 setup.py build_ext --inplace && cd ..

%install
mkdir -p %{buildroot}/opt/nfsqa/pynfs
cp -a nfs4.0 %{buildroot}/opt/nfsqa/pynfs/
cp -a nfs4.1 %{buildroot}/opt/nfsqa/pynfs/
cp -a lib %{buildroot}/opt/nfsqa/pynfs/ 2>/dev/null || true
mkdir -p %{buildroot}%{_bindir}
install -m 755 bin/nfsqa-pynfs-run %{buildroot}%{_bindir}/

%files
/opt/nfsqa/pynfs/
%{_bindir}/nfsqa-pynfs-run

%changelog
* Sat Apr 05 2026 NextNFS QA <nfsqa@localhost> - 1.0.0-1
- Initial RPM packaging of pynfs for NFS QA testing
