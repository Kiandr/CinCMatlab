% frameRecordInit.m
function frame = frameRecordInit (firstDataIndex, lastDataIndex)

	frame.startIndex = firstDataIndex;
	frame.endIndex =   lastDataIndex;
 	frame.minima = 0;
	frame.minIndex = 1;
	frame.maxima = 0;
	frame.maxIndex = 1;
	frame.mean = 0;
	frame.std = 0;