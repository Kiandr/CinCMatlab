% load an apply to all of the PPGsignal 
% clear all;

start = ((1000*60)*(48));
endOf = start+(60*1000);

% Parameters as presented in dosens of papers by Convertino and Linder
close all;
parameters.MINIMUM_PEAK_TO_VALLEY = 0.3e3;
parameters.MINIMUM_WINDOW_SIZE = 20;
parameters.MAXIMUM_WINDOW_SIZE = 40;
parameters.MAXIMUM_WINDOW_CHANGE = 10;

% 6 Flex
% 7 Nonin ForeHead
% 8 BP
% inputData = load ('../MatData/Subj2.mat');


 % Build a TimerArray to condult GetMorph. This corresponds to 1000K/s
 % samplring frequency
 %===
% time = zeros(length(PPGFlex_Filtered2),1);
%for i = 1:length(PPGFlex_Filtered2) 
 % time(i) = i;
%end
%==

 PPGFlex = inputData.VarName8(start:endOf);
 % Get RIIV 
 PPGFlex_Filtered=smooth(PPGFlex,0.1,'rloess');
 % Get PPG
 PPGFlex_Filtered2=smooth(PPGFlex,0.002,'rloess');
 

   


    % Get Features 
    ppgFeatures = getMorphology (PPGFlex_Filtered2, time, parameters);
    ppgFeaturesRIIV = getMorphology (PPGFlex_Filtered, time, parameters);
    
        % plot your output PPG raw and Filtered
figure(2)
plot(PPGFlex_Filtered2);
hold
plot(ppgFeatures.timePeaks,ppgFeatures.peaks);
hold off  
figure(1)
plot(PPGFlex_Filtered);
hold
plot(PPGFlex);
hold off    
figure (3)
plot(PPGFlex_Filtered);
hold on 
plot(ppgFeaturesRIIV.timePeaks,ppgFeaturesRIIV.peaks)
hold on
plot(PPGFlex_Filtered2);
hold off

  