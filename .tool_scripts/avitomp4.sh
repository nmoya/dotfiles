#!/bin/bash
function convert_all_to_mp4()
{
	for file in *.avi ; do
		local bname=`basename "$file" .avi`
		local mp4name="$bname.mp4"
		ffmpeg -i "$file" "$mp4name"
		done
}
convert_all_to_mp4
