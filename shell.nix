with import <nixpkgs> { };

mkShell {
  name = "vulkan-dev";
  packages = [ ];

  buildInputs = [
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

  shellHook = ''
    echo "Welcome to my Vulkan Shell"
    echo "vulkan loader: ${vulkan-loader}"
    echo "vulkan headers: $vulkan-headers}"
    echo "validation layer: ${vulkan-validation-layers}"
    echo "tools: ${vulkan-tools}"
    echo "tools-lunarg: ${vulkan-tools-lunarg}"
    echo "extension-layer: ${vulkan-extension-layer}"
  '';

  LD_LIBRARY_PATH =
    "${glfw}/lib:${freetype}/lib:${vulkan-loader}/lib:${vulkan-validation-layers}/lib:${wayland}/lib:${libxkbcommon}/lib";

  VULKAN_SDK = "${vulkan-tools-lunarg}";
  VK_LAYER_PATH = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  PATH = "${vulkan-tools}/bin:"
    + builtins.getEnv "PATH"; # sets up vulkan application environment

  VK_DRIVER_FILES =
    "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

  # WINIT_UNIX_BACKEND = "x11"; # to default to x11, didn't create environment variables for
}
