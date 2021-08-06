## Description
Builds the Boost libraries.

Supported target systems: Linux x86-64, Windows x86-64 (via preconfigured cross-compilation) \
Supported build systems: Linux


## Tested prerequisites
* Kubuntu 18.04 x64
* git 2.17.1: `sudo apt install git`
* (optional) dolphin git integration: `sudo apt install dolphin-plugins`
* g++ 7.5.0: `sudo apt install build-essential`
* g++-mingw-w64-x86-64 7.3.0: `sudo apt install mingw-w64 mingw-w64-tools`


## How to build
Run `_ensure_dependency-recursive_Multiarch.sh` in a terminal.


## How to switch the target OS?
**Local build** \
Change the `standardPlatform` variable in the `_platform_config.sh` file.

**In a script** \
Use `changePlatformTo "$platformLinux"` or `changePlatformTo "$platformWindows"` and then run `_ensure_dependency-recursive_Multiarch.sh`.

