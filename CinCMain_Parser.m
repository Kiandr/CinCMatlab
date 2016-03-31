% clear all;


% Parameters as presented in dosens of papers by Convertino and Linder
close all;
parameters.MINIMUM_PEAK_TO_VALLEY = 0.3e3;
parameters.MINIMUM_WINDOW_SIZE = 20;
parameters.MAXIMUM_WINDOW_SIZE = 40;
parameters.MAXIMUM_WINDOW_CHANGE = 10;


 %inputData = load ('../MatData/Subj1.mat');

 y=36000;
 x=1;
 
 % Build a TimerArray to condult GetMorph. This corresponds to 1000K/s
 % samplring frequency
  time = zeros(y,1);
for i = 1:y
  time(i) = i;
end

for i=1:2
   
    PPGFlex = inputData.VarName7(x:y);
    PPGFlex_Filtered=smooth(PPGFlex,0.1,'rloess');

    % Get Features 
    ppgFeatures = getMorphology (PPGFlex_Filtered, time, parameters);
    
        % plot your output PPG raw and Filtered
    figure(i)
    plot(PPGFlex_Filtered);
   % hold 
    %plot(PPGFlex_Filtered);
    hold 
    plot(ppgFeatures.timePeaks,ppgFeatures.peaks);
    
    
    
    x=y;
    y=(y+2000);
    
    
end
    
%%
%
%%