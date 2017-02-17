#!/bin/bash

luaversion=${LUA}
latesttag=$(git describe --tags)

#need to compare latest released version with latest published in Luarocks version too
if [ "$luaversion" == "lua=5.2" ]; then
	echo "Latest tag = ${latesttag}"
	echo "Lua version = $luaversion"
fi
