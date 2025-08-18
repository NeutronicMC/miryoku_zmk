{
  description = "Miryoku‑ZMK dev shell (macOS, GNU Arm Embedded)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["aarch64-darwin" "x86_64-darwin"] (system: let
      pkgs = import nixpkgs {inherit system;};
      pythonPkgs = pkgs.python311.withPackages (p: [
        p.west
        p.pyelftools
        p.pillow
        p.intelhex
      ]);
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.gcc-arm-embedded
          pkgs.cmake
          pkgs.ninja
          pkgs.dtc
          pkgs.ccache
          pkgs.git
          pkgs.dfu-util
          pythonPkgs
        ];

        shellHook = ''
          export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
          export GNUARMEMB_TOOLCHAIN_PATH=${pkgs.gcc-arm-embedded}
          echo "Zephyr using GNU Arm tool‑chain at $GNUARMEMB_TOOLCHAIN_PATH"
        '';
      };
    });
}
