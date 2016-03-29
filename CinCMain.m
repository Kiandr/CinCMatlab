% clear all;
close all;
parameters.MINIMUM_PEAK_TO_VALLEY = 0.3e3;
parameters.MINIMUM_WINDOW_SIZE = 20;
parameters.MAXIMUM_WINDOW_SIZE = 40;
parameters.MAXIMUM_WINDOW_CHANGE = 10;

 inputData = load ('S1.mat');
%PPG = inputData.data(1:1000,5);

PPG = smooth((inputData.data(1:100000,5)),0.1,'loess');
time = zeros(size(PPG));
for i = 1:numel(PPG)
  time(i) = i;
end
 ppgFeatures = getMorphology (PPG, time, parameters);

 figure(1)
%plot(ppgFeatures.timePeaks,ppgFeatures.peaks);
%hold
plot(time,PPG);
hold
 plot(ppgFeatures.timeInstHR,ppgFeatures.instHR);

plot(ppgFeatures.timePeaks,ppgFeatures.peaks);
hold
% plot(ppgFeatures.timeRiseFallTime,ppgFeatures.riseTime);

