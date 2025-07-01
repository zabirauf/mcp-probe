{
  description = "MCP Trace - A TUI to probe the calls between MCP client and server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, crane, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default;
        
        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

        commonArgs = {
          src = craneLib.cleanCargoSource (craneLib.path ./.);
          strictDeps = true;
          version = "0.2.0";
          
          buildInputs = with pkgs; [
            # Add runtime dependencies if needed
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # Darwin specific dependencies
            pkgs.libiconv
          ];

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
        };

        # Build dependencies only
        cargoArtifacts = craneLib.buildDepsOnly (commonArgs // {
          pname = "mcp-trace-deps";
        });

        # Build the mcp-trace unified binary
        mcp-trace = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
          pname = "mcp-trace";
          cargoExtraArgs = "--package mcp-trace";
          
          meta = with pkgs.lib; {
            description = "A TUI to probe the calls between MCP client and server";
            homepage = "https://github.com/zabirauf/mcp-trace";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
            mainProgram = "mcp-trace";
          };
        });

      in
      {
        checks = {
          # Run tests
          mcp-trace-test = craneLib.cargoTest (commonArgs // {
            inherit cargoArtifacts;
          });

          # Check clippy (allow warnings for now)
          mcp-trace-clippy = craneLib.cargoClippy (commonArgs // {
            inherit cargoArtifacts;
            cargoClippyExtraArgs = "--all-targets -- --warn clippy::all";
          });
        };

        packages = {
          inherit mcp-trace;
          default = mcp-trace;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = mcp-trace;
          };
        };

        devShells.default = craneLib.devShell {
          checks = self.checks.${system};
          
          packages = with pkgs; [
            rust-analyzer
            cargo-watch
            cargo-edit
            cargo-outdated
          ];

          RUST_LOG = "debug";
        };
      });
}