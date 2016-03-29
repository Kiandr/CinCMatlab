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

numberOfFrames = 1;
for subjectIndex = subjectIndices
 	   disp (['Detecting standing for Subject ', int2str(subjectIndex), ...
 			 ', Trials ', int2str(trialIndices)]);
	for trialIndex = trialIndices

		ppgFeaturesVector  = ppgFeaturesMatrix(subjectIndex, trialIndex, :)  ;
		ppgVector = PPG_Matrix(subjectIndex, trialIndex, :);

		for i = 3 %1:length(ppgVector);
 			SubjectTrialString = ['Subject ', int2str(subjectIndex) , ...
									' Trial ', int2str(trialIndex), ...
									' Sensor ', char(PulseOxDescription{subjectIndex, trialIndex, i});];
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
%			peakSkewness = zeros(1, numberOfValleys);
%			peakCumSumSkewness = zeros(1, numberOfValleys);

 			[peakData, peakLengths, numberOfPeaks] = getPeaks(ppg, ppgFeatures);
% 			[peakData, peakLengths, numberOfPeaks] = getNormalizedPeaks(ppg, ppgFeatures);


			% prepare data into a matrix for ploting with contour and surf
			%---------------------------------------------------------------
			maxLength = max(peakLengths);
			allData = zeros(numberOfPeaks, maxLength);
			for k = 1:numberOfPeaks
				allData (k,1:peakLengths(k)) = peakData{k};
			end

if 1
			figure (hPulseFigure)
			set(gcf, 'name', 'Surf Plot of All the Peaks', 'numbertitle', 'off');
			clf
			axes1 = axes(...
	            'Parent', hPulseFigure);
			surf([1:maxLength], ...
					ppgFeatures.timeValleys(1:numberOfPeaks)', ...
					allData, 'Parent', axes1)
			ylabel ('Time(sec)')
			title (SubjectTrialString)
			set(axes1, ...
			    'CameraPosition',[114.6 -688.3 8.784],...
			    'CameraUpVector',[-9.312 158.8 0.4647] )
			 set(axes1, ...
				  'CameraPosition',[411.7 -1281 6162],...
  				   'CameraUpVector',[-0.1954 0.7671 10.1])
else
			figure (hPulseFigure)
			image(allData)
end

			figure(hHistogramFigure)
			set(gcf, 'name', 'Countour Plot of All the Peaks', 'numbertitle', 'off');
			 contourf(ppgFeatures.timeValleys(1:numberOfPeaks)', ...
			 			[1:maxLength], ...
			 			allData', 15)
			xlabel ('Time(sec)')
			ylabel ('Data Samples for each peak')
			title (SubjectTrialString)
 			suspend
			figurePosition = get(gcf, 'Position');
			figureSize = figurePosition(3:4);

% 			M(numberOfFrames) = getframe(gcf);
 			numberOfFrames = numberOfFrames + 1;

	   	end
	end
end

