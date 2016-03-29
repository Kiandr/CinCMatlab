% findFeatureBounds.m
function interval = findFeatureBounds (index, vector, maxIndex)
% Stephen Linder 5-02-04
%-----------------------------------------------------------
% find the features in the vector that bound the index
% and return the range
%
% features are non zero values
%------------------------------------------------------------



	% Search away from the origin
	endIndex = index;
	while ( (endIndex < maxIndex ) & (vector(endIndex) == 0)  )
		endIndex = endIndex + 1;
	end

	% Search towards the origin of the array
	startIndex = index;
	while ( (startIndex > 1) & (vector(startIndex) == 0)  )
		startIndex = startIndex - 1;
	end


	interval = startIndex:endIndex;
