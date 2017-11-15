#!/bin/bash

rm ~/github/test-corpus/praat/cog.txt
rm ~/github/test-corpus/praat/formants.txt
for textgrid in `ls /Users/niko/github/test-corpus/praat/0000/*.TextGrid`
do

    wav=$(echo $textgrid | sed 's/.TextGrid/.wav/g')
 #   output=$(echo $textgrid | sed 's/.TextGrid/.formants/g')

    /Applications/Praat.app/Contents/MacOS/Praat --run peak_spectral_COG.praat $textgrid $wav
    /Applications/Praat.app/Contents/MacOS/Praat --run get_formants.praat $textgrid $wav >> ~/github/test-corpus/praat/formants.txt 

done
