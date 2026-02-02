#!/bin/bash
# Usage: tools/optimize-image.sh input.png images/mineral-name/specimen.jpg
sips -s format jpeg -s formatOptions 85 \
     --resampleHeightWidthMax 2000 \
     "$1" --out "$2"
