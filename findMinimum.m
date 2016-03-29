% findMinimum.m
function [minIndex, minima] = findMinimum (interval)
% Stephen Linder 5-02-04
%-----------------------------------------------------------
% find the minimum in the interval
%
% if there are multiple minimas then we will take the middle
% of the left valley
%
%------------------------------------------------------------

 	minima = min(interval);
	minIndices = find(interval == minima);

	% see if the minimas are spread
	% and if so only take the left side
	%-----------------------------------
	minLength =  length(minIndices);
	indiceDelta =  minIndices(minLength) - minIndices(1);
	if ( (indiceDelta / length(minIndices)) > 2 )

		% the spread in the minima is too high, there are gaps in the
		% minima
		% for now just assume there are two minimas and
		% truncate the list at the largest gap
		%-------------------------------------
		delta = minIndices(2:minLength) -  minIndices(1:minLength-1);
		maxDeltaIndex = find(delta == max(delta) ) ;

		minIndices = minIndices(1:maxDeltaIndex) ;
	end
	minIndex = 	minIndices(ceil(length(minIndices)/2));
