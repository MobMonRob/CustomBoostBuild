#!/bin/bash


readonly boostVersion="boost-1.58.0"
readonly mingwLibPath1="/usr/x86_64-w64-mingw32/lib"

local -r minwLibPath2Beginning="/usr/lib/gcc/x86_64-w64-mingw32"
local -r minwLibPath2FoundArray=($(find "$minwLibPath2Beginning"/*-posix -maxdepth 0 -mindepth 0 -type d -printf '%f\n'))
readonly mingwLibPath2="$minwLibPath2Beginning/${minwLibPath2FoundArray[0]}"
