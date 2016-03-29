% getPeaks.m
function [peakData, peakLengths, numberOfPeaks] = getPeaks(ppg, ppgFeatures)
%--------------------------------------------------------------
% get the data between each pair of valleys.
%
% Minimum ppg value subtracted from all the data so it can be plotted.
%
% if you want normalized data call getNormalizedPeaks
%--------------------------------------------------------------
global NONIN_TIME_STEP


numberOfPeaks = length(ppgFeatures.timeValleys) - 1;
peakLengths = zeros(1, numberOfPeaks);

meanPPG = median (ppg);

% extract data from between peaks
for k = 1:numberOfPeaks
	startIndex =    floor(ppgFeatures.timeValleys(k) / NONIN_TIME_STEP)	+ 1;
	endIndex = floor(ppgFeatures.timeValleys(k+1) / NONIN_TIME_STEP);
	data = ppg(startIndex:endIndex)';

	peakData{k} = data - meanPPG;
	peakLengths(k) = length(data);
end
