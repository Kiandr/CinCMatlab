close all;
clear all;
addpath('/Users/kiandr/Documents/MATLAB/morph');
load('../S8/S8.mat')
%=====================================================================
%CountsPeaksinRIIV
ppgFlexPeaksRIIV     = getMorphology (PPGFlex_Filtered, time, parameters);
ppgForePeaksRIIV     = getMorphology (PPGFore_Filtered, time, parameters);
%=====================================================================
% Plotting:

figure(1)
plot(time,PPGFlex_Filtered2,'.-')
hold on
plot(ppgFeatures.timePeaks,ppgFeatures.peaks,'*');
plot(time,PPGFlex_Filtered,'o')
plot(ppgFlexPeaksRIIV.timePeaks,ppgFlexPeaksRIIV.peaks,'-mo',...
                'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',10);
%plot(PPGFore_Filtered)
hold off


figure(2)
hold on

plot(PPGFore_Filtered2,'.-')
plot(ppgFeaturesRIIV.timePeaks,ppgFeaturesRIIV.peaks,'*');
plot(time,PPGFore_Filtered,'o')
plot(ppgForePeaksRIIV.timePeaks,ppgForePeaksRIIV.peaks,'-mo',...
                'LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',10);
%plot(PPGFore_Filtered)

hold off

figure(3)
plot(Respiration_airflow)



peaksFlex = length(ppgFlexPeaksRIIV.peaks);
peaksFore = length(ppgForePeaksRIIV.peaks);

BARes = BA(A,B);

