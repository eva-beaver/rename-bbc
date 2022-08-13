#!/bin/bash
# Changing i to readable form for mediainfo
filename="/home/eva/bbc//totp/Top_of_the_Pops_-_29_04_1993_m0019tp0_original.mp4"
filename=$(echo $filename | sed -r 's/[ ^]+/\\&/g')
echo $filename
# Go Through files, storing the output to mediadur variable
mediadur=$(mediainfo --Inform="General;%Album%;General;%Title%" "$filename");
#echo $mediadur;
mediadur=$(mediainfo --Inform="General; Album: %Album% \\r\\n Title: %Title%\\r\\n" "$filename");
echo $mediadur;
mediadur=$(mediainfo --output=JSON "$filename"  |  jq '. | {album: .media.track[0].Album, title: .media.track[0].Title}');
echo $mediadur;
echo "----------------------";
items="album: .media.track[0].Album"
items+=", title: .media.track[0].Title"
items+=", grouping: .media.track[0].Grouping"
items+=", genre: .media.track[0].Genre"
items+=", contenttype: .media.track[0].ContentType"
items+=", description: .media.track[0].Description"
items+=", recorded_date: .media.track[0].Recorded_Date"
items+=", lyrics: .media.track[0].Lyrics"
items+=", comment: .media.track[0].Comment"
items+=", longdescription: .media.track[0].extra.LongDescription"
items+=", duration: .media.track[0].Duration"
items+=", filesize:.media.track[0].FileSize"
items+=", format:.media.track[0].Format"
items+=", fileextension:.media.track[0].FileExtension"
mediadur=$(mediainfo --output=JSON "$filename"  |  jq '. | {'"$items"'}');
echo $mediadur;
echo "----------------------";
pathname="/home/eva/bbc//Escape to the Country/"
filename="Escape_to_the_Country_Series_19_-_65._Dorset_m000byxs_original.mp4"
mediadur=$(mediainfo --output=JSON "$pathname$filename"  |  jq '. | {'"$items"'}');
echo $mediadur;

#mediainfo --Output=$'General;File Name: %FileName%\\r\\nOverall Bit Rate: %OverallBitRate/String%\\r\\nDuration: %Duration/String3%\\r\\nFormat: .%FileExtension%\\r\\nSize: %FileSize/String%\nVideo;\\r\\nDimensions: %Width%x%Height%\\r\\n' input.file


#mediadur=$(mediainfo --Inform="General;%Duration%" "$i");
