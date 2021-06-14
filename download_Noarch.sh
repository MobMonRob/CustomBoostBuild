#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"

run() {
	local -r boostLibDir="$noarchTmp/boost"

	rm -rdf "$boostLibDir"
	mkdir -p "$boostLibDir"

	#Old git version does not support some arguments
	#git clone https://github.com/boostorg/boost.git --branch="$BoostVersion" --depth=1 --recursive --jobs="$((2*$(nproc)))" --shallow-submodules "$boostLibDir"

	git clone https://github.com/boostorg/boost.git --branch="$boostVersion" --depth=1 --recursive "$boostLibDir"
}

run_bash run $@

