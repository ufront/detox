#!/bin/bash
# Package for haxelib
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Delete the existing zip
rm -f domtools.zip

# Create links to our externs
ln -fs ../domtools
ln -fs ../doc/haxedoc.xml

# Zip all the pieces together
zip domtools.zip haxelib.xml haxedoc.xml
zip -r domtools.zip domtools/*

