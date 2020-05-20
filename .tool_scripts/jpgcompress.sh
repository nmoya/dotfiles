#!/bin/bash
QUALITY=85
if [ $# -ge 1 ]
then
    QUALITY=$1
fi
function lossless_jpg_compression()
{
    echo "Compression maitaining quality $QUALITY%";
    for file in *.{jpg,JPG} ; do
        echo "Processing $file ...";
        convert -interlace Plane -gaussian-blur 0.05 -quality $QUALITY% $file $file;
    done
}
lossless_jpg_compression