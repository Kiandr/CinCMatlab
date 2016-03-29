function [ppgFeatures] = getMorphology (ppg, time, parameters)

% getMorphology


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find peaks of ppg data using spl code

[minArray maxArray frameArray] = findPeaks (ppg, parameters);

% get the indices in which the array is one, a flag that a max or a min has occurred.
maxIndices = find(maxArray);
minIndices = find(minArray);
maxFrameIndex = length(frameArray);

ppgFeatures.peaks = ppg(maxIndices);
ppgFeatures.timePeaks = time(maxIndices)'; % corresponding time of peaks
ppgFeatures.valleys = ppg(minIndices);
ppgFeatures.timeValleys = time(minIndices)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate pulse height
% check if ppgPeak vector is same size as ppgValley, if not, make them = by
% truncating one or the other
if(length(maxIndices) > length(minIndices)) % there are more maxs than mins
    ppgFeatures.peaks = ppgFeatures.peaks(1:length(minIndices));
    ppgFeatures.timePeaks = ppgFeatures.timePeaks(1:length(minIndices));
else % there are more mins than maxs
    ppgFeatures.valleys = ppgFeatures.valleys(1:length(maxIndices));
    ppgFeatures.timeValleys = ppgFeatures.timeValleys(1:length(maxIndices));
end
ppgFeatures.pulseHeight =  ppgFeatures.peaks - ppgFeatures.valleys; % pulse height


% Calculate rise time and fall time in units of samples
%------------------------------------------------------
ppgFeatures.riseTime = zeros(size(minIndices)-1); % initialize rise time array
ppgFeatures.fallTime = zeros(size(minIndices)-1);
len = length(minIndices);
ppgFeatures.timeRiseFallTime = zeros(len-1, 1);
for (x = 1:len-1)
    minIndex = 	minIndices(x);
    maxIndex = findNextFeatureIndex(minIndex, maxArray);
    ppgFeatures.riseTime(x) = maxIndex - minIndex;
    ppgFeatures.fallTime(x) = minIndices(x+1) - maxIndex;
    ppgFeatures.timeRiseFallTime(x)= time(maxIndex);
end





% inst HR in bpm  // also the RSA signal
%---------------------------------------------------
ppgFeatures.instHR  = 60 ./ diff(ppgFeatures.timePeaks);
ppgFeatures.timeInstHR = ppgFeatures.timePeaks(2:length(ppgFeatures.timePeaks));


