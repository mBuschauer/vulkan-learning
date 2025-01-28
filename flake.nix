{
  description = "Vulkan Dev Flake";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }@inputs:
    let
      lib = nixpkgs.lib;
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell rec {
        name = "Test Env";
        nativeBuildInputs = with pkgs;
          [

          ];

        buildInputs = with pkgs; [
          rustup
          openssl
          pkg-config

          xorg.libX11
          xorg.libXau
          xorg.libXdmcp

          wayland
          wayland-protocols
          libxkbcommon

          glfw
          freetype

          vulkan-volk
          vulkan-tools
          vulkan-loader
          vulkan-headers
          vulkan-validation-layers
          vulkan-tools-lunarg
          vulkan-extension-layer

          shaderc # GLSL to SPIRV compiler - glslc
          renderdoc # Graphics debugger
          tracy # Graphics profiler
        ];

        packages = with pkgs;
          [

          ];

        shellHook = with pkgs; ''
          echo "Welcome to my Vulkan Shell"
          echo "vulkan loader: ${vulkan-loader}"
          echo "vulkan headers: $vulkan-headers}"
          echo "validation layer: ${vulkan-validation-layers}"
          echo "tools: ${vulkan-tools}"
          echo "tools-lunarg: ${vulkan-tools-lunarg}"
          echo "extension-layer: ${vulkan-extension-layer}"
        '';

        LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";

        VULKAN_SDK =
          "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
        VK_LAYER_PATH =
          "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
        PATH = "${vulkan-tools}/bin:"
          + builtins.getEnv "PATH"; # sets up vulkan application environment

        VK_DRIVER_FILES =
          "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      };
    };
}
