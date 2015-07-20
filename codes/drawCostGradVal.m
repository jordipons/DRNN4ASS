clc;
clear all;
close all;

%dir='/home/idrojsnop/WSP_8Jul/DRNN_SourceSeparation_jp0/models/training/LOCAL_Standard_run1_NOnorm__737__model_RNN2_win3_h10_l3_r0.05_64ms_Inf_softabs_linearout_RELU_spectrum_cutSilence0_trn0_c1e-10_c0.001/';
dir='/home/idrojsnop/WSP_8Jul/DRNN_SourceSeparation_jp0/models/training/LOCAL_Standard_run1_norm__424__model_RNN2_win3_h10_l3_r0.05_64ms_Inf_softabs_linearout_RELU_spectrum_cutSilence0_trn0_c1e-10_c0.001/';

filename_cost = [dir,'_cost.txt'];
cost=importdata(filename_cost);
maskNan=isnan(cost);
cost(maskNan)=[];
figure;
hold on;
plot(cost)

filename_val = [dir,'_val.txt'];
val=importdata(filename_val);
tar_GSDR=val(:,1)';
tar_GSIR=val(:,2)';
tar_GSAR=val(:,3)';
other_GSDR=val(:,4)';
other_GSIR=val(:,5)';
other_GSAR=val(:,6)';
figure;
hold on;
plot(tar_GSDR)
plot(tar_GSIR,'red')
plot(tar_GSAR,'green');
title('Vocals')
legend('GSDR','GSIR','GSAR');
figure;hold on;
plot(other_GSDR)
plot(other_GSIR,'red')
plot(other_GSAR,'green');
title('Background')
legend('GSDR','GSIR','GSAR');

filename_grad = [dir,'_grad.txt'];
grad=importdata(filename_grad);
figure;plot(grad)

[valueMax,modelID]=max(sum(val,2));
betterModel=(modelID-1)*20