function [Mean, Upper, Lower,r,p,MSE,Stan]=BA(A,B);

d=(B-A);

Upper=mean(d)+1.96*std(d);
Lower=mean(d)-1.96*std(d);
Mean=mean(d);

Ave=(A+B)/2;
close
plot(Ave,d,'*')
hold
plot(min(Ave):0.001:max(Ave),repmat(Lower,length(min(Ave):0.001:max(Ave)),1),'k-')
plot(min(Ave):0.001:max(Ave),repmat(Upper,length(min(Ave):0.001:max(Ave)),1),'k-')
plot(min(Ave):0.001:max(Ave),repmat(Mean,length(min(Ave):0.001:max(Ave)),1),'k')
%legend('','Lower limit','Upper limit','Mean diff');

f=Upper-Lower;
ylim([-1.5*f 1.5*f]);


[R P]=corrcoef(A,B);
p=P(1,2);
r=R(1,2);
Stan=std(d);

MSE=mse(A,B);