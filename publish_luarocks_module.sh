#!/bin/bash

latesttag=$(git describe --tags)
echo checking out ${latesttag}
