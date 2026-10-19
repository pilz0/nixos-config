# upstream flake only exposes linux systems, so build it here from its uv.lock
{
  lib,
  callPackage,
  python3,
  inputs,
}:
let
  inherit (inputs.hydra-mcp.inputs) pyproject-nix uv2nix pyproject-build-systems;
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = inputs.hydra-mcp.outPath; };
  pythonSet = (callPackage pyproject-nix.build.packages { python = python3; }).overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.wheel
      (workspace.mkPyprojectOverlay { sourcePreference = "wheel"; })
    ]
  );
in
pythonSet.mkVirtualEnv "hydra-mcp-env" workspace.deps.default
