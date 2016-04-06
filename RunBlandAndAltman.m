clear all
flex  = [13,13,14,12,11,18,15,12,09,23];
fore  = [11,11,15,13,15,15,14,13,11,15];
Nasal = [14,21,20,14,23,20,15,19,11,17];
[Mean, Upper, Lower,r,p,MSE,Stan] = BA(flex,fore);
