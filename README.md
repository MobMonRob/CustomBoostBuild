## Description
Builds the Boost libraries.

Supported target systems: Linux x86-64, Windows x86-64 (via preconfigured cross-compilation) \
Supported build systems: Linux


## Tested prerequisites
* Kubuntu 20.04 x64 LTS
* git 2.25.1: `sudo apt install git`
* g++ 9.3.0: `sudo apt install build-essential`
* x86_64-w64-mingw32-g++ 9.3: `sudo apt install mingw-w64 mingw-w64-tools`


## How to build
Run `_ensure_dependency-recursive_Multiarch.sh` in a terminal.


## How to switch the target OS?
**Local build** \
Change the `standardPlatform` variable in the `_platform_config.sh` file.

**In a script** \
Use `changePlatformTo "$platformLinux"` or `changePlatformTo "$platformWindows"` and then run `_ensure_dependency-recursive_Multiarch.sh`.


## Caution
Don't use the gcc `-flto` flag for cross-compilation of a project that includes boost. This can lead to seemingly not connected and therefore difficult to debug errors.

