with import <nixpkgs> { };

mkShell {
  name = "vulkan-dev";
  packages = [
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
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools # vulkaninfo
    shaderc # GLSL to SPIRV compiler - glslc
    renderdoc # Graphics debugger
    tracy # Graphics profiler
    vulkan-tools-lunarg # vkconfig
  ];

  buildInputs = with pkgs; [ glfw freetype ];


  LD_LIBRARY_PATH = "${glfw}/lib:${freetype}/lib:${vulkan-loader}/lib:${vulkan-validation-layers}/lib:${wayland}/lib:${libxkbcommon}/lib";
  
  VULKAN_SDK = "${vulkan-headers}";
  VK_LAYER_PATH = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  PATH = "${vulkan-tools}/bin:" + builtins.getEnv "PATH"; # sets up vulkan application environment 

  # WINIT_UNIX_BACKEND = "x11"; # to default to x11, didn't create environment variables for
}
