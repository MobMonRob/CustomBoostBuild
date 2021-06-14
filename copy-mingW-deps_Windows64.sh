#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"

run() {
	cp -L -u "$mingwLibPath1/libwinpthread-1.dll" "$currentTarget"
	cp -L -u "$mingwLibPath2/libgcc_s_seh-1.dll" "$currentTarget"
	cp -L -u "$mingwLibPath2/libstdc++-6.dll" "$currentTarget"
}

run_bash run $@

