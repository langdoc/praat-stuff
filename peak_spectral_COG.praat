# SpectralCOG Finder
# Will Styler, written for Alec Buchner way back when
#
# This script takes the peak spectral frequency and spectral COG from a selected sound in the objects window.
#
# Modified by Niko Partanen in different ways in Autumn 2017. 

form Files
    word textgrid chain
    word sound chain
endform

resultfile$ = "/Users/niko/github/test-corpus/praat/cog.txt"
header_row$ = "SoundFile" + tab$ + "Word" + tab$ + "Segment" + tab$ + "Timepoint" + tab$ + "DurationMS" + tab$ + "HighestFreq" + tab$ + "HighestAmp" + tab$ + "SpectralCOG" + newline$
#fileappend "'resultfile$'" 'header_row$'
endif

sn = Read from file: sound$
selectObject: sn

grid = Read from file: textgrid$
selectObject: grid
tg$ = selected$ ("TextGrid")

numint = Get number of intervals... 3
for i from 1 to numint
	select TextGrid 'tg$'
	label$ = Get label of interval... 3 'i'

# Would be nice and useful if this section worked, now some context is lost
#	Select previous interval
#	prev_label$ = Get label of interval
#	Select next interval
#
	if label$ = "s" or label$ = "z" or label$ = "S" or label$ = "Z" or label$ = "s_j" or label$ = "z_j"
		start = Get starting point... 3 'i'
		end = Get end point... 3 'i'
		midpoint = start + ((end - start) / 2)
		select TextGrid 'tg$'
		wordint = Get interval at time... 1 'midpoint'
		select TextGrid 'tg$'
		wordlab$ = Get label of interval... 2 'wordint'
		# Get 1/3 point
		p1 = start + ((end - start) / 3)
		p2 = midpoint
		p3 = start + (2*((end - start) / 3))
		duration = (end - start) * 1000
		durationms = (end - start)

		tp = p2
		tpn = 2
		call peakmeasure

	endif
endfor

procedure peakmeasure

	storeda = 0
	storedf = 0
	#select Sound 'sn$'
	selectObject: sn
	Extract part... p1 p3 "rectangular" 1 0

	#Spectrogram settings... 0 15000 0.05 50

	To Spectrum... yes

	#To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
	#To Spectrum (slice): 0.5

	slice$ = selected$ ("Spectrum")
	select Spectrum 'slice$'
	cog = Get centre of gravity... 3
	#select Spectrum 'slice$'
	To Ltas (1-to-1)
	ltas$ = selected$ ("Ltas")
	select Ltas 'ltas$'
	numbins = Get number of bins
	for b from 1 to numbins
		ba = Get value in bin... 'b'
		bf = Get frequency from bin number... 'b'
		if bf > 1000
			if ba > storeda
				storeda = ba
				storedf = bf
			endif
		endif
	endfor

	result_row$ = "'sound$'" + tab$ + "'wordlab$'" + tab$ + "'label$'" + tab$ + "'tpn'" + tab$ + "'durationms'" + tab$ + "'storedf'" + tab$ + "'storeda'" + tab$ + "'cog'" + tab$ + "'p1'" + tab$ + "'p3'" + newline$
	fileappend "'resultfile$'" 'result_row$'
	#fileappend 'result_row$'
	select all
	#minus Sound sn
	#minus TextGrid tg
	#Remove

endproc
