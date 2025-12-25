{
  description = "C++ dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        llvm = pkgs.llvmPackages_latest;
      in
        {
          devShells.default = with pkgs; mkShell {
            buildInputs = [
              curl
              openssl
            ];
            nativeBuildInputs = [
              gcc
              pkg-config
              automake
              autoconf
              gnumake
              llvm.clang
              llvm.lldb
              llvm.libllvm
              llvm.libcxx
              clang-tools
              gdb
              mold
              cmake
              stdenv.cc.cc.lib
              bear
            ];
            CLANGD_FLAGS = [
              "--query-driver=${llvm.clang}/bin/clang,${llvm.clang}/bin/clang++"
            ];
            # NIX_CFLAGS_COMPILE = [
            #   # "-isystem ${gcc}/include/c++/${gcc.version}"
            #   # "-isystem ${llvm.libcxx.dev}/include/c++/v1"
            # ];
            shellHook = ''
            exec zsh
            '';
          };
        }
    );
}
