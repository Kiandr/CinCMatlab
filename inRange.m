% findFeatureBounds.m
function flag = inRange (index, range)
% Stephen Linder 5-02-04
%-----------------------------------------------------------
% find if the index is in the range
%
%------------------------------------------------------------



 if (( index >= range(1)) & ...
     (index <= range(length(range))) )

	 flag = true;
 else
	 flag = false;
 end