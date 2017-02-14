#!/bin/bash

latesttag=$(git describe --tags)
echo checking out ${latesttag}

luaversion=${LUA}
if [ "$luaversion" == "lua=5.2" ]; then
	echo "$luaversion: we can publish module in this case!"
else
	echo "$luaversion: not valid case!"
fi
