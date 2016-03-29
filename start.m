% MorphAll.m
%
% Calculates and saves the peaks and valleys for all the data.
%
% Run LoadStandupData before running this script.
%----------------------------------------------------------------


parameters.MINIMUM_PEAK_TO_VALLEY = 0.3e4;
parameters.MINIMUM_WINDOW_SIZE = 20;
parameters.MAXIMUM_WINDOW_SIZE = 40;
parameters.MAXIMUM_WINDOW_CHANGE = 5;




	disp(' Loading data from file standupData...')
	ppg = load('/Users/kiandr/Google Drive/LBNP_Feb13&Feb14/Test/S2.mat');
  	  %  time = zeros(len)
       % [ppgFeatures] = getMorphology (ppg, time , parameters);
  	   % ppgFeaturesMatrix{subjectIndex, trialIndex, i} = ppgFeatures;

% save standupFeatures   ppgFeaturesMatrix



