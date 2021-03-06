#!/bin/bash

current_artifact_version=$1
lua_version=${LUA}
latest_tag=$(git describe --abbrev=0 --tags)

echo "~~~~~~~~~~~~~~~~~"
echo "~~ Latest tag = ${latest_tag}"
echo "~~ Lua version = $lua_version"
echo "~~ Current lvk version = $current_artifact_version"
echo "~~~~~~~~~~~~~~~~~"

#need to compare latest released version with latest published in Luarocks version too
if [ "$lua_version" == "lua=5.2" ] && [ "$current_artifact_version" != "${latest_tag}" ]; then
    echo "We can publish new module"
else
    echo "Current version is already published"
fi
