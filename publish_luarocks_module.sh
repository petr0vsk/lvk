#!/bin/bash

latesttag=$(git describe --tags)
echo checking out ${latesttag}

luaversion=$(lua -v)
echo luaversion
