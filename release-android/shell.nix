{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  android-nixpkgs = callPackage (import (builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
    ref = "main";
  })) {
    # Default; can also choose "beta", "preview", or "canary".
    channel = "stable";
  };

  android-sdk = android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    build-tools-31-0-0
    ndk-21-3-6528147
    platform-tools
    platforms-android-31
    emulator
  ]);

  my-python = pkgs.python3;
  python-with-my-packages = my-python.withPackages (p: with p; [
    pillow
  ]);
in
  mkShell {
    buildInputs = [
        android-sdk
        jdk11
        python-with-my-packages
    ];
  }