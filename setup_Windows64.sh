#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"


run() {
	local -r fullLocalTmp="$(realpath "$windowsTmp")"
	local -r fullLocalTarget="$(realpath "$windowsTarget")"
	local -r boostDir="$fullLocalTmp/boost"
	local -r stageDir="$fullLocalTmp/stage"
	local -r buildDir="$fullLocalTmp/build"
	local -r boostLibDir="$stageDir/lib"

	copy_boost_dir

	bootstrap_boost

	build_boost

	link_so
}


copy_boost_dir() {
	local -r noarchBoostDir="$noarchTmp/boost"

	rm -rdf "$boostDir"
	mkdir -p "$boostDir"

	cp -r -L -l "$noarchBoostDir" -T "$boostDir"
}


bootstrap_boost() {
	cd "$boostDir"

	git clean -d -f -X
	rm -rdf "$buildDir"

	./bootstrap.sh

	cd "$scriptDir"
}

build_boost() {
	cd "$boostDir"

	echo "using gcc : : x86_64-w64-mingw32-g++-posix ;" > ./user-config.jam

	rm -rdf "$stageDir"

	local -r compilerArgs="-fPIC -flto -std=c++14 -w -O3"

	local -r boostLibsToBuild="--with-thread"

	#Boost library "Context" wont compile with mingw and is therefore excluded.
	#See: http://boost.2283326.n4.nabble.com/build-bootstrap-sh-is-still-broken-td4653391i20.html
	#See: https://svn.boost.org/trac10/ticket/7262
	#Possible fixes could be:
	#1. a newer version of boost
	#2. proviede PATH to MASM in Wine

	#Please pay attention that boost::thread uses win32 as underlying threadapi whereas std::thread uses winpthread as underlying threadapi. There could be problems if intermixed. But currently unavoidable.

	#--jobs="$((3*$(nproc)))"
	#Debugging: --jobs=1
	#Debugging: -d+2
	#https://www.boost.org/doc/libs/1_54_0/libs/iostreams/doc/installation.html
	#--without-wave --without-log --without-test --without-python --without-context --without-coroutine
	./b2 -q -sNO_BZIP2=1 $boostLibsToBuild binary-format=pe --user-config=user-config.jam --jobs="$((3*$(nproc)))" --layout=tagged --toolset=gcc-mingw threadapi=win32 architecture=x86 address-model=64 target-os=windows optimization=speed cflags="$compilerArgs" cxxflags="$compilerArgs" variant=release threading=multi link=static runtime-link=static --stagedir="$stageDir" --build-dir="$buildDir" variant=release stage

	cd "$scriptDir"
}


link_so() {
	rm -f $boostLibDir/*test*.a

	#Needs a user defined cpp_main function
	rm -f $boostLibDir/libboost_prg_exec_monitor*.a

	#ToDo: Fix boost python lib runtime dependency
	rm -f $boostLibDir/*python*.a

	#Erratic  error - windows only
	rm -f $boostLibDir/*log*.a

	#Erratic  error - windows + posix only
	rm -f $boostLibDir/*wave*.a

	local -r boostLibs=$(find "$boostLibDir" -maxdepth 1 -mindepth 1 -type f -printf '-l:%f ')

	echo "linking... (needs some time)"

	rm -rdf $fullLocalTarget/lib*
	mkdir -p "$fullLocalTarget"

	x86_64-w64-mingw32-g++-posix -shared \
	-O3 -flto  \
	-Wl,-Bstatic -Wl,--start-group -Wl,--whole-archive \
	-L"$boostLibDir" $boostLibs \
	-Wl,--no-whole-archive -Wl,--end-group -Wl,-Bdynamic \
	-o "$fullLocalTarget/libboost.dll" \
	-Wl,--as-needed -Wl,--no-undefined -Wl,--no-allow-shlib-undefined \
	-Wl,--out-implib,"$fullLocalTarget/libboost.dll.a"
}

run_bash run $@

