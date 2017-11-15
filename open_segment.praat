# In my use this script is called from a shell script which
# is easier to call from different environments.
# So on my Mac I call it like this:
# sendpraat_carbon praat "execute open_segment.praatscript file.wav file.TextGrid 1 2"
# So the shell script basically gives the PraatScript variables as shell script variables.
#
# #!/bin/bash
# if [ $# -eq 4 ]
# then
#    ~/bin/sendpraat_carbon praat "execute /Users/niko/github/praat-stuff/open_segment.praatscript $1 $2 $3 $4"
# else
#    echo "invalid argument please pass only one argument "
# fi
#
# The main advantage this is that I can easily wrap it in R into something like:
#
# open_praat <- function(filename, start, end){
#   system("bash open_segment.sh {filename}.wav {filename}.TextGrid {start} {end}")
# }
#

form Info
     word textgrid_file chain
     word sound chain
     positive start
     positive end
endform

sound = Read from file: sound$
textgrid = Read from file: textgrid_file$

plusObject: sound

View & Edit

#editor: sound
#    Zoom: start, end
#    Select: start, end
#endeditor
