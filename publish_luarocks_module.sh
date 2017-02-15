#!/bin/bash

luaversion=${LUA}
if [ "$luaversion" == "lua=5.2" ]; then
	latesttag=$(git describe --tags)
	echo "-------"
	echo "Need to check for new releases (via tags)"
	echo checking out ${latesttag}
	echo "-------"
	echo "$luaversion: we can publish module in this case!"
else
	echo "$luaversion: not valid case!"
fi
