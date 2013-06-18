#!/bin/sh

cp -R haxelib.json haxedoc.xml src LICENSE.txt README.md package

cd package
rm package.zip
zip -r package.zip haxelib.json haxedoc.xml src LICENSE.txt README.md
cd ..
