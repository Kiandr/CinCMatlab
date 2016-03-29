% findSkewnessAndKurtosis
%[skewness, kurtosis] = findSkewnessAndKurtosis()



if (~exist('ppgFeaturesMatrix'))
	disp(' Loading data from file standupFeatures ...')
	load standupData;
	load standupFeatures
end

MAX_SUBJECT_NUMBER = 11;
MAX_NUMBER_OF_TRIALS = 3;
NUMBER_OF_SENSORS = 3;

subjectIndices = 1:MAX_SUBJECT_NUMBER;
trialIndices = 1:MAX_NUMBER_OF_TRIALS;

initStandUp

parameters.MINIMUM_PEAK_TO_VALLEY = 0.3e4;
parameters.MINIMUM_WINDOW_SIZE = 20;
parameters.MAXIMUM_WINDOW_SIZE = 40;
parameters.MAXIMUM_WINDOW_CHANGE = 5;



if(~exist('hHistogramFigure'))
	hHistogramFigure = figure ;
end

if(~exist('hPulseFigure'))
	hPulseFigure = figure ;
end

if(~exist('hSkewnessFigure'))
	hSkewnessFigure = figure ;
end


for subjectIndex = subjectIndices
 	   disp (['Detecting standing for Subject ', int2str(subjectIndex), ...
 			 ', Trials ', int2str(trialIndices)]);
	for trialIndex = trialIndices

		ppgFeaturesVector  = ppgFeaturesMatrix(subjectIndex, trialIndex, :)  ;
		ppgVector = PPG_Matrix(subjectIndex, trialIndex, :);

		for i = 3 %1:length(ppgVector);
			len = length(ppgVector{i});
			timeVector = [0:NONIN_TIME_STEP:(len * NONIN_TIME_STEP - NONIN_TIME_STEP)]; % time vector for ppg

			% plot ppg data with valleys marked
			%------------------------------------------
			figure (hSkewnessFigure)
			set(gcf, 'name', 'Peak skewness', 'numbertitle', 'off');
			hold off
			plot(timeVector, ppgVector{i}, 'g') ;
			hold on
			plot(ppgFeaturesVector{i}.timeValleys, ppgFeaturesVector{i}.valleys, 'r.')

			% characterize each peak of the ppg data
			%----------------------------------------
			ppgFeatures = ppgFeaturesVector{i};
			ppg = ppgVector{i};
			numberOfValleys = length(ppgFeatures.timeValleys) - 1;
			peakSkewness = zeros(1, numberOfValleys);
			peakCumSumSkewness = zeros(1, numberOfValleys);

			% extract data from between peaks
			for k = 1:numberOfValleys
				startIndex =    floor(ppgFeatures.timeValleys(k) / NONIN_TIME_STEP)	+ 1;
				endIndex = floor(ppgFeatures.timeValleys(k+1) / NONIN_TIME_STEP);
				data = ppg(startIndex:endIndex)';

				% if we find the skewness of the data then we would
				% only then find the skewness of the histogram of the data.
				% Not necessarily what we want do
				%
				% however if we subtract the peak we would get
				data  = data - min(data);
				data2 = cumsum(-data);

				peakSkewness(k) = skewness(data);
				peakCumSumSkewness(k) = skewness(data2);
				%	if (k > 10 & peakSkewness(k) < min(peakSkewness(1:10)))
				if 1 %(peakSkewness(k) < 0.05)
					disp (['time: ', num2str(timeVector(startIndex)), ' skewness: ', num2str(peakSkewness(k)), ...
							'  kurtosis: ', num2str(peakCumSumSkewness(k))])
					figure (hPulseFigure)
					plot(data)
					figure(hHistogramFigure)
					hist (data, 20)
	    			suspend
				end

			end
			figure (hSkewnessFigure)
				  h(1) = plot(ppgFeaturesVector{i}.timeValleys(1:numberOfValleys), ...
				  		peakSkewness * 1000 + 2^15, 'b');
				  h(2) = plot(ppgFeaturesVector{i}.timeValleys(1:numberOfValleys), ...
				  		peakCumSumSkewness * 1000 + 2^15, 'r') ;
				  % plot baseline of skewness
				  plot([ppgFeaturesVector{i}.timeValleys(1), ...
				  		ppgFeaturesVector{i}.timeValleys(numberOfValleys)], ...
						[2^15, 2^15])
			legend(h, {'Skewness of histogram of  peak', ...
					  'Skewness of histogram of the cumulative sum of peak'})
			SubjectTrialString = ['Subject ', int2str(subjectIndex) , ...
									' Trial ', int2str(trialIndex), ...
									' Sensor ', char(PulseOxDescription{subjectIndex, trialIndex, i});];
			title (SubjectTrialString)
	   	end
	end
end

