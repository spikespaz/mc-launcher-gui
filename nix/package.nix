{
# Must be provided in `callPackage` for accuracy.
sourceRoot ? ./.., platforms ? [ "x86_64-linux" ],
#
lib,
#
cargo, rustc, makeRustPlatform,
#
llvmPackages_16, wayland, freetype, fontconfig, python3
#
}:
let
  manifest = lib.importTOML "${sourceRoot}/Cargo.toml";

  rustPlatform = makeRustPlatform {
    cargo = cargo;
    rustc = rustc;
    stdenv = llvmPackages_16.stdenv;
  };
in rustPlatform.buildRustPackage {
  pname = manifest.package.name;
  version = manifest.package.version;

  src = sourceRoot;
  cargoLock.lockFile = "${sourceRoot}/Cargo.lock";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ wayland freetype fontconfig ];

  meta = {
    inherit (manifest.package) description homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.spikespaz ];
    inherit platforms;
    mainProgram = manifest.package.name;
  };
}
