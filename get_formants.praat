vowel_tier = 3
label_tier = 2

form Files
    comment Give full paths to TextGrid and WAV files.
    word textgrid_file chain
    word sound chain
endform

#textgrid_file$ = "/Users/niko/langdoc/upperezva_i/praat-phon/corrected/kpv_izva20140404IgusevJA-b-042.TextGrid"
#sound$ = "/Users/niko/langdoc/upperezva_i/praat-phon/corrected/kpv_izva20140404IgusevJA-b-042.wav"

sound = Read from file: sound$
textgrid = Read from file: textgrid_file$

#endform

# # formant = selected ("Formant")
# textgrid = selected ("TextGrid")
# snd = selected ("Sound")
# sound$ = selected$ ("Sound")

# If you don't want to generate a Formant ahead of time, you can specify your
# configuration for the Formant calculation here. This runs on every run of
# this script, and it does take some time, so if you're going to run it many
# times you should just generate it the once.

formant_time_step = 0.01
formant_maximum_number = 5
formant_maximum_hz = 5500
formant_window_length = 0.075
formant_preemphasis_from_hz = 50

selectObject: sound
# To Formant (burg)... 0.0025 5 5500 0.025 50
formant = To Formant (burg)... formant_time_step formant_maximum_number formant_maximum_hz formant_window_length formant_preemphasis_from_hz

selectObject: textgrid
numberOfIntervals = Get number of intervals... 'vowel_tier'

appendInfoLine: "Time	Start	Mid	End	Avg	Name	Word	Vowel	f1	f2	f3"

# Look through all intervals, picking out the ones with a non-blank label
for interval to numberOfIntervals
    vowel$ = Get label of interval... vowel_tier interval
    if vowel$ <> ""
	# if the interval has an unempty vowel label, get its start and end:
	start = Get starting point... vowel_tier interval
	start = start + 0.005
	end = Get end point... vowel_tier interval
	midpoint = (start + end) / 2

	# And get the word (label)
	word_interval = Get interval at time... label_tier start
	word_label$ = Get label of interval... label_tier word_interval

	# get the formant values at those points
    	selectObject: formant
	@getFormants: 'start'
	@PrintLn: string$('start'), "start", vowel$, word_label$, getFormants.f1, getFormants.f2, getFormants.f3
	@getFormants: 'midpoint'
	@PrintLn: string$('midpoint'), "midpoint", vowel$, word_label$, getFormants.f1, getFormants.f2, getFormants.f3
	@getFormants: 'end'
	@PrintLn: string$('end'), "end", vowel$, word_label$, getFormants.f1, getFormants.f2, getFormants.f3

#	# And special case the average formants
	mean1 = Get mean: 1, start, end, "Hertz"
	mean2 = Get mean: 2, start, end, "Hertz"
	mean3 = Get mean: 3, start, end, "Hertz"
	@PrintLn: "'start':'end'", "avg", vowel$, word_label$, mean1, mean2, mean3
	selectObject: textgrid
    endif
endfor

procedure getFormants: .pointInTime
    # Get the formants
    #.f1 = Get value at time... 1 .pointInTime Hertz Linear
    .f1 = Get mean: 1, .pointInTime, .pointInTime + 0.008, "Hertz"
    #.f2 = Get value at time... 2 .pointInTime Hertz Linear
    .f2 = Get mean: 2, .pointInTime, .pointInTime + 0.008, "Hertz"
    #.f3 = Get value at time... 3 .pointInTime Hertz Linear
    .f3 = Get mean: 3, .pointInTime, .pointInTime + 0.008, "Hertz"
endproc

# Get the formants at a given point in time
# Args:
#  .pointInTime: A double number of seconds in the file
#  .timeLabel$: The label you want to give this point in time, eg "start"
procedure PrintLn: .pointInTime$, .timeLabel$, .vowelLabel$, .wordLabel$, .f1, .f2, .f3
    # Save result to text file:
    resultline$ = "'.pointInTime$'	'.timeLabel$'	'sound$'	'.wordLabel$'	'.vowelLabel$'	'.f1'	'.f2'	'.f3'"
    appendInfoLine: "'resultline$'"
endproc

# selectObject: textgrid, snd
