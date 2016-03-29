% getNormalizedPeaks.m
function [peakData, peakLengths, numberOfPeaks] = getNormalizedPeaks(ppg, ppgFeatures)
%--------------------------------------------------------------
% get the data between each pair of valleys.
%
% Data is normalized so that the peak is always 1.
%
%--------------------------------------------------------------
global NONIN_TIME_STEP


numberOfPeaks = length(ppgFeatures.timeValleys) - 1;
peakLengths = zeros(1, numberOfPeaks);


% extract data from between peaks
for k = 1:numberOfPeaks
	startIndex =    floor(ppgFeatures.timeValleys(k) / NONIN_TIME_STEP)	+ 1;
	endIndex = floor(ppgFeatures.timeValleys(k+1) / NONIN_TIME_STEP);
	data = ppg(startIndex:endIndex)';
	minPPG = min (data);
	height = max(data) - minPPG;
 	peakData{k} = (data - minPPG) / height;
	peakLengths(k) = length(data);
end
