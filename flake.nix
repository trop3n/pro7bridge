{
  description = "Combined Python and Node.js development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          venvDir = ".venv";
          
          packages = with pkgs; [
            # Python environment
            python312
            python312Packages.pip
            python312Packages.venvShellHook
            python312Packages.poetry-core
            python312Packages.requests
            
            # Node.js environment
            node2nix
            nodejs
            nodePackages.pnpm
            yarn
          ];

          shellHook = ''
            # Set up Python virtual environment
            if [ -d "$venvDir" ]; then
              echo "Existing Python virtual environment found in $venvDir"
            else
              echo "Creating Python virtual environment in $venvDir"
              python -m venv $venvDir
            fi
            source $venvDir/bin/activate
          '';
        };
      });
    };
}