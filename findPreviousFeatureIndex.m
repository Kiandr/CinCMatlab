% findPreviousFeatureIndex.m
% Stephen Linder 4-30-04
%-----------------------------------------------------------
% find the first feature that occured before the index
% features are non-zero elements in the vector
%-----------------------------------------------------------
function featureIndex = findPreviousFeatureIndex (index, vector)

	featureIndex = index;
	while ( (featureIndex > 1) & (vector(featureIndex) == 0)  )
		featureIndex = featureIndex - 1;
	end

