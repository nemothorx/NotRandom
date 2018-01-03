#!/bin/bash

# creates a logo based on the layout of

# N
# O RANDOM
# T
# SO  VERY
# HOLISTIC

# with each block of text being a different, random font

# limit fonts with this filter
ffilter=${1:-.}

fontlist=$(identify -list font | grep Font: | cut -d" " -f 4- | grep $ffilter )
fontcount=$(echo "$fontlist" | wc -l)

declare -A label

labl[1]="N\nO\nT"
labl[2]="RANDOM"
labl[3]="SO VERY"
labl[4]="HOLISTIC"
font[1]=$(echo "$fontlist" | shuf -n 1)
font[2]=$(echo "$fontlist" | shuf -n 1)
font[3]=$(echo "$fontlist" | shuf -n 1)
font[4]=$(echo "$fontlist" | shuf -n 1)

# make the base images

for count in {1..4} ; do 
    convert -background white \
	    -fill black \
	    -font "${font[$count]}" \
	    -size 1000x1000 \
	    -gravity center \
	    -kerning 0 \
	     label:"${labl[$count]}" \
	    -depth 8 \
	    -trim +repage \
	     out$count.png
    echo "${font[$count]}"
    size[$count]=$(identify -format %G out$count.png)
    width[$count]=${size[$count]%x*}
    height[$count]=${size[$count]#*x}
    echo ${size[$count]} ${width[$count]} ${height[$count]}
done

# ok, now resize and organise

convert out1.png -geometry x${height[2]} out1a.png

montage -label '' out1a.png \
	-label '' out2.png \
	-background white \
	-geometry +10+10 \
	row1.png


convert out3.png -geometry x${height[4]} out3a.png

montage -label '' out3a.png \
	-label '' out4.png \
	-background white \
	-geometry +10+10 \
	row2.png

montage -label '' row1.png \
	-label '' out3.png \
	-label '' out4.png \
	-background white \
	-geometry +10+10 \
	-tile 1x \
	layout1.png
