{
# Must be provided in `callPackage` for accuracy.
sourceRoot ? ./.., platforms ? [ "x86_64-linux" ],
#
lib,
#
cargo, rustc, makeRustPlatform,
#
llvmPackages_16, wayland, freetype, fontconfig, python3,
#
pkg-config, qtwayland, wrapQtAppsHook
#
}:
let
  manifest = lib.importTOML "${sourceRoot}/Cargo.toml";

  stdenv = llvmPackages_16.stdenv;
  rustPlatform = makeRustPlatform {
    inherit stdenv;
    cargo = cargo;
    rustc = rustc;
  };
in rustPlatform.buildRustPackage {
  pname = manifest.package.name;
  version = manifest.package.version;

  src = sourceRoot;
  cargoLock.lockFile = "${sourceRoot}/Cargo.lock";

  noDefaultFeatures = true;
  buildFeatures = ["backend-qt"];

  nativeBuildInputs = [ python3 ]
    ++ lib.optionals stdenv.isLinux [ pkg-config wrapQtAppsHook ];
  buildInputs = [ wayland freetype fontconfig ]
    ++ lib.optionals stdenv.isLinux [ wayland qtwayland ];

  meta = {
    inherit (manifest.package) description homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.spikespaz ];
    inherit platforms;
    mainProgram = manifest.package.name;
  };
}
