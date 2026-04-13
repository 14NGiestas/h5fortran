(import
  (
    let
      lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    in
    fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
      sha256 = lock.nodes.nixpkgs.locked.narHash;
    }
  )
  { }
).callPackage
  (
    {
      mkShell,
      cmake,
      ninja,
      gcc,
      hdf5,
      zlib,
      python3,
      git,
      pkg-config,
    }:
    mkShell {
      name = "h5fortran";
      packages = [
        cmake
        ninja
        gcc
        hdf5
        zlib
        python3
        git
        pkg-config
      ];

      shellHook = ''
        echo "h5fortran: GCC (default) + HDF5 + CMake + Ninja"
        echo "Build: cmake -Bbuild -G Ninja --workflow --preset default"
      '';

      HDF5_DIR = "${hdf5.dev}";
    }
  )
  { }
