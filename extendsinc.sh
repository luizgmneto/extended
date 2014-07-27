#!/bin/bash
# diffuse inc extended files

directory=`dirname $0`
echo "Working in $directory"
cd $directory
cp ./*.inc ../Ancestromania/AncestroComponents/
cp ./*.inc ../ManFrames/
cp ./*.inc ../XMLFrames/

