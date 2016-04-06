close all;
clear all;
addpath('/Users/kiandr/Documents/MATLAB/CinC/MatData/');
load('LBNP2016/S1.mat')
for i=1:11
disp (['S',int2str(i)','.mat']);
load (['S',int2str(i)','.mat']);

NumberOfChannels = 9;
startBase = ((1));
start_20 = ((1000*60)*(12));
start_30 = ((1000*60)*(24));
start_40 = ((1000*60)*(36));
start_50 = ((1000*60)*(48));
start_60 = ((1000*60)*(60));
startRest = ((1000*60)*(72));

D.Base = data(startBase:(start_20),1:NumberOfChannels);
D.L20 = data(start_20:(start_30-1),1:NumberOfChannels);
D.L30 = data(start_30:(start_40-1),1:NumberOfChannels);
D.L40 = data(start_40:(start_50-1),1:NumberOfChannels);
D.L50 = data(start_50:(start_60-1),1:NumberOfChannels);
if (length(D.L50)>=(1000*60)*(12))
D.L60 = data(start_60:(startRest-1),1:NumberOfChannels);
if (length(D.L60)>=(1000*60)*(12))
D.Rest = data(start_20:length(data(:,1)),1:NumberOfChannels);
end
end

save  (['D',int2str(i)','.mat'])
display(['Saved D',int2str(i)','.mat'])
end


