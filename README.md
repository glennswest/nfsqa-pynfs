# nfsqa-pynfs

Debian packaging for [pynfs](https://github.com/kofemann/pynfs) — the NFSv4 protocol conformance test suite.

pynfs speaks RPC directly to port 2049 (no kernel mount needed) and tests NFSv4.0 (~565 tests) and NFSv4.1 protocol conformance.

## Build

```bash
./build.sh
```

Produces `nfsqa-pynfs_*.deb` in the parent directory.

## Usage

```bash
sudo apt install ./nfsqa-pynfs_*.deb

# NFSv4.0 tests
cd /opt/nfsqa/pynfs/nfs4.0
./testserver.py <SERVER>:/export --maketree all

# NFSv4.1 tests
cd /opt/nfsqa/pynfs/nfs4.1
./testserver.py <SERVER>:/export --maketree all

# Or use the wrapper script:
nfsqa-pynfs-run 4.0 <SERVER>:/export --maketree all
nfsqa-pynfs-run 4.1 <SERVER>:/export --maketree all
```
