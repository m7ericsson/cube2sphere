#!/bin/bash

imagePath=$1
outputName=$2

cubeSuffixes=("l" "r" "b" "f" "u" "d")

tmpDir="/images/${outputName}"
outputDir="/outputs"
rm -fr "${tmpDir}"
mkdir "${tmpDir}"

for cubeSuffix in "${cubeSuffixes[@]}"; do
  curl --request GET -sL \
    --url "${imagePath}/pano-${cubeSuffix}.jpg" \
    --output "${tmpDir}/cube_${cubeSuffix}.jpg"
done

krpanotools cube2sphere \
  -l="${tmpDir}/cube_l.jpg" \
  -f="${tmpDir}/cube_f.jpg" \
  -u="${tmpDir}/cube_u.jpg" \
  -r="${tmpDir}/cube_r.jpg" \
  -b="${tmpDir}/cube_b.jpg" \
  -d="${tmpDir}/cube_d.jpg" \
  -o="${outputDir}/${outputName}.jpg"

rm -fr ${tmpDir}
