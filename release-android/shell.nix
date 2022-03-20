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
in
  mkShell {
    buildInputs = [
        android-sdk
        jdk11
        python39
    ];
  }