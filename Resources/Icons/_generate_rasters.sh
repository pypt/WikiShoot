#!/bin/sh

#
# Generates raster images for iOS from SVG sources.
#
# Requires ImageMagick.
#

imageMagickOpts=" -background None"

for i in `ls *.svg`; do
	echo "Creating raster for '$i'..."
	convert $imageMagickOpts $i ${i%.*}.png
	echo "Creating @2x raster for '$i'..."
	convert -density 145% $imageMagickOpts $i ${i%.*}@2x.png
done

echo "Done."
