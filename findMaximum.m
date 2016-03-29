% findMaximum.m
function [maxIndex, maxima] = findMaximum (interval)
% Stephen Linder 5-02-04
%-----------------------------------------------------------
% find the maximum in the interval
%
% if there are multiple maximas then we will take the middle
% of the left peak
%
%------------------------------------------------------------
	maxima = max(interval);
	maxIndices = find(interval == maxima);

	% see if the peaks are spread out
	% and if so only take the right side
	%-----------------------------------
	maxLength =  length(maxIndices);
	indiceDelta =  maxIndices(maxLength) - maxIndices(1);
	if ( (indiceDelta / length(maxIndices)) > 2 )

		% the spread in the maximas is too high, there are gaps in the
		% maximas
		% for now just assume there are two maximas and
		% truncate the list at the largest gap
		%-------------------------------------
		delta = maxIndices(2:maxLength) -  maxIndices(1:maxLength-1);
		maxDeltaIndex = find(delta == max(delta) );

		maxIndex = maxIndices(1:maxDeltaIndex);
	end
	maxIndex = 	maxIndices(ceil(length(maxIndices)/2));
