% findPeaks.m
function [minArray, maxArray, frameArray] = findpeaks (data, parameters)
% Stephen Linder 5-02-04
%-----------------------------------------------------------
% find the features peaks and valleys in the data
% INPUT:
% 	data -
%
% OUTPUT:
%	minArray - every minimum is marked with a 1
%	maxArray - every maximum is marked with a 1
%------------------------------------------------------------

DATA_LENGTH = length(data);

minArray = zeros(DATA_LENGTH, 1);
maxArray = zeros(DATA_LENGTH, 1);

lastPeakToPeakValue = 0;


MINIMUM_PEAK_TO_VALLEY = parameters.MINIMUM_PEAK_TO_VALLEY;
MINIMUM_WINDOW_SIZE = parameters.MINIMUM_WINDOW_SIZE;
MAXIMUM_WINDOW_SIZE = parameters.MAXIMUM_WINDOW_SIZE;
MAXIMUM_WINDOW_CHANGE = parameters.MAXIMUM_WINDOW_CHANGE;

frameWidth = 2 * MAXIMUM_WINDOW_SIZE;
startIndex = 1;
frameIndex = 1;
while startIndex < DATA_LENGTH


	endIndex = startIndex + frameWidth;
	if (endIndex >DATA_LENGTH)
		break
	end
	frameArray(frameIndex) = frameRecordInit(startIndex, endIndex);
	out(['FRAME ', num2str(frameIndex), 	...
		   ': Range[',num2str(startIndex), ', ', num2str(endIndex), ']', ...
		  ' Width[', num2str(frameWidth), ']']);

	frameArray(frameIndex).startIndex = startIndex;
	frameArray(frameIndex).endIndex = endIndex;

	windowIndices = startIndex:endIndex;
 	window = data(windowIndices);

	%%%%%%%%%%%%%%%%%%%%%%%%%
	% find valleys and peaks
	%%%%%%%%%%%%%%%%%%%%%%%%
	[minIndex, minima] = findMinimum(window) ;
	minIndex = minIndex + startIndex - 1;
	[maxIndex, maxima] = findMaximum(window);
	maxIndex =  maxIndex + startIndex - 1;


	out (['[max, min] = [', num2str(minima), ', ', num2str(maxima), ']'])
%  if (startIndex >	 200)
%	  out('helpp')
%  end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% erase any other minimas that occur since the last peak that are larger
	% than the current minima. Do this only if if the last frame peak is to the
	% left of the current minima.
	%-------------------------------------------------
	if ( frameIndex > 1)

		if ( (minIndex < maxIndex) )
            % check peak to peak range
			checkRange = findFeatureBounds(minIndex, maxArray, ...
								min([endIndex, maxIndex]));
        else
			% check from dected peak to the end of the frame
			checkRange = maxIndex:endIndex;;
		end
		minIndices = checkRange(1) - 1 + ...
						find(minArray(checkRange) == 1);
		if (isempty(minIndices))
			 minArray(minIndex) = 1;  % the new minimum is the only one
		elseif( inRange(minIndex, checkRange) )
			% two minimas are in the same range (peak to peak)
			% calculate new minima for range
			[minIndex, minima] = findMinimum(data(checkRange)) ;
			minIndex = minIndex + checkRange(1) - 1 ;
			minArray(minIndices) = 0;
			minArray(minIndex) = 1;
		else   % the two minimas are in different ranges
			minArray(minIndex) = 1;
		end

	else
		minArray(minIndex) = 1;
	end

	% erase any maximas that occur since the last valley in the
	% previous frames and before the valley in this frame that are
	% smaller than the peak we just found.
	%-------------------------------------------------
	if ( frameIndex > 1)
 		if ((maxIndex < minIndex) | ...
				(maxIndex < findPreviousFeatureIndex(endIndex, minArray)) )

			valleytoValleyRange = findFeatureBounds(maxIndex, minArray, ...
											min([endIndex, minIndex]));
			maxIndices = valleytoValleyRange(1) - 1 + ...
							find(maxArray(valleytoValleyRange) == 1);
			if (isempty(maxIndices))
				% set new maximum
				maxArray(maxIndex) = 1;
			elseif( (data(maxIndices(1)) <= data(maxIndex))   )
				[maxIndex, maxima] = findMaximum(data(valleytoValleyRange));
				maxIndex =  maxIndex + valleytoValleyRange(1) - 1;
				maxArray(maxIndices(1)) = 0;
				maxArray(maxIndex) = 1;
			end
		elseif  (minIndex < maxIndex)

			% there could still be two maximas after the last minima
			% because the frame is to short to catch a long rising edge
			% (most rising edges seem fast while the falling edges are
			% the slow ones.
			%---------------------------------------------------------
			sinceMinRange = [minIndex:endIndex];
			maxArray(sinceMinRange) = 0;
            maxArray(maxIndex) = 1;
		else
			maxArray(maxIndex) = 1;
		end
 	else
		maxArray(maxIndex) = 1;
	end



	frameArray(frameIndex).minima = minima;
	frameArray(frameIndex).minIndex = minIndex;
	frameArray(frameIndex).maxima = maxima;
	frameArray(frameIndex).maxIndex = maxIndex;
	frameArray(frameIndex).mean = mean(window);
	frameArray(frameIndex).std = std(window);
    %frameArray(frameIndex)

 	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	% plot the latest frame if plotting is enabled
 	%------------------------------------------------------
 	global 	REALTIME_PLOT hRealTimeFigure filename

	if startIndex >	 300
  		REALTIME_PLOT = true;
	end
 	REALTIME_PLOT = false;
	if(REALTIME_PLOT)
		figure(hRealTimeFigure)
			hold off
			plot(data(1:endIndex), 'b.-')
			hold on
			title (['IR data from ',  filename])

			% plot minimas
			indices = find(minArray);
			plot (indices, data(indices), 'r^')
			indices = find(maxArray);
			h = plot (indices,data(indices), 'r*');
			set(h, 'MarkerSize', 10, 'LineWidth', 1)

			%=======================
			% plot frame boundaries
			%=======================

			for i=1:frameIndex
				NUMBER_OF_BAR_LEVELS = 4;
				y = mean(data) + 40 * mod(i-1, NUMBER_OF_BAR_LEVELS);
				h = plot (frameArray(i).startIndex, y, 'g>');
				h = plot (frameArray(i).endIndex, y, 'g<');

				range = [frameArray(i).startIndex, frameArray(i).endIndex];
				h = plot (range,[y y], 'g');
				set(h, 'LineWidth', 1)
			end

			drawnow
      		 	suspend
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% start next frame half way from the minima to the maximum;
	% but past the minima or the maxima
	%----------------------------------------------------------
	startIndex =   max([floor((maxIndex + minIndex ) / 2 ), ...
					   floor((startIndex + endIndex) / 2)]);
	if ( (data(startIndex)== data(minIndex)) & ...
		 (minIndex < maxIndex))
		  startIndex = floor((startIndex + maxIndex) / 2 );
	end
	frameIndex = frameIndex + 1;

	% 6-30-05 SPL
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% changed  PULSE_WIDTH_TO_FRAME_RATIO from 1.0 to 0.8
	% Some of the standup subjects have such a fast heart rate
	% when they stand up that the window would get two peaks.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% frame size should be proportional to the width of the last pulse
	% use data from previous frames
	%------------------------------------------------------------------
    PULSE_WIDTH_TO_FRAME_RATIO = 0.8;

	% will return zero if no previous peak-to-peak interval exists
	%---------------------------------------------------------------
	intervalBetweenPeaks = findPreviousFeatureInterval (startIndex, maxArray);

	previousFrameWidth = frameWidth;
	frameWidth = max([MINIMUM_WINDOW_SIZE, ...
					 floor(intervalBetweenPeaks * PULSE_WIDTH_TO_FRAME_RATIO)] );
	change = frameWidth - previousFrameWidth;
	if ( abs(change)  > MAXIMUM_WINDOW_CHANGE)
		 frameWidth	= previousFrameWidth + MAXIMUM_WINDOW_CHANGE * sign(change);
	end

	frameWidth = min ([frameWidth, MAXIMUM_WINDOW_SIZE]);

	% insure that the new interval extends at
	% least as far as the last one.
	%----------------------------------------
	if ( frameWidth + startIndex < endIndex)
		   frameWidth =  endIndex - startIndex + 1;
	end

end

