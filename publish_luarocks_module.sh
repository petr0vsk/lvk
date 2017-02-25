#!/bin/bash

current_artifact_version=$1
lua_version=${LUA}
latest_tag=$(git describe --tags)

#need to compare latest released version with latest published in Luarocks version too
if [ "$lua_version" == "lua=5.2" ]; then
	echo "Latest tag = ${latest_tag}"
	echo "Lua version = $lua_version"
	echo "Current lvk version = $current_artifact_version"
fi
