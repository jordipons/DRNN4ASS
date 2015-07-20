function [targets,Target_ObjectiveMeasures,Other_ObjectiveMeasures] = test_mir1k_general_kl_bss3(modelname_in, theta, eI, stage, iter)

if strcmp(stage,'dev')
    eval_files= dir( [eI.ValDataPath,filesep, '*wav']);
else    
    eval_files= dir( [eI.DataPath,filesep, '*wav']);
end

modelname=[modelname_in, '_'];

disp(modelname)
fprintf('\n');

GSDR_bss3.soft = zeros(numel(eval_files),1 );
GSIR_bss3.soft = zeros(numel(eval_files),1 );
GSAR_bss3.soft = zeros(numel(eval_files),1 );
Other_GSDR_bss3.soft = zeros(numel(eval_files),1 );
Other_GSIR_bss3.soft = zeros(numel(eval_files),1 );
Other_GSAR_bss3.soft = zeros(numel(eval_files),1 );
GSDR_bss3.len =  zeros(numel(eval_files),1 );

for ifile=1:numel(eval_files) % each test songs
    testname=eval_files(ifile).name(1:end-4);
    if (strcmp(eval_files(ifile).name,'.') || ...
        strcmp(eval_files(ifile).name,'..')), continue; end

    if strcmp(stage,'dev')
        [test_wav,fs]=wavread([eI.ValDataPath,'/',eval_files(ifile).name]);        
    else    
        [test_wav,fs]=wavread([eI.DataPath,'/',eval_files(ifile).name]);    
    end

    s1 = test_wav(:,2); % singing
    s2 = test_wav(:,1); % music
    eI.fs= fs;
    GSDR_bss3.len(ifile)= size(test_wav,1);

    maxLength=max([length(s1), length(s2)]);
    s1(end+1:maxLength)=eps;
    s2(end+1:maxLength)=eps;

    if ~isfield(eI, 'norm_data')
        disp('normalizing input data!')
        s1=s1./sqrt(sum(s1.^2));
        s2=s2./sqrt(sum(s2.^2));
    elseif eI.norm_data==1
        disp('normalizing input data!')
        s1=s1./sqrt(sum(s1.^2));
        s2=s2./sqrt(sum(s2.^2));        
    end
    mixture=s1+s2;

    winsize = eI.winsize;    nFFT = eI.nFFT;    hop = eI.hop;    scf=eI.scf;
    windows=sin(0:pi/winsize:pi-pi/winsize);

    if eI.train_mode==3
        testmode=3; % formulate one data per cell
    else
        testmode=1; %test
    end
    [test_data_cell, target_ag, mixture_spectrum]= ...
                                formulate_data_test(mixture, eI, testmode);

    if isfield(eI, 'isdiscrim')  && eI.isdiscrim==2, % KL
        [ cost, grad, numTotal, pred_cell ] = drdae_discrim_joint_kl_obj...
            (theta, eI, test_data_cell, [], mixture_spectrum, true, true);
    elseif isfield(eI, 'isdiscrim')  && eI.isdiscrim==1, % EUCLIDEAN
        [ cost, grad, numTotal, pred_cell ] = drdae_discrim_obj(theta, eI, ...
                                            test_data_cell, [], true, true);
    else
        [ cost, grad, numTotal, pred_cell ] = drdae_obj(theta, eI, test_data_cell, [], true, true);
    end

    outputdim=size(pred_cell{1},1)/2;
    pred_source_noise=pred_cell{1}(1:outputdim,:);
    pred_source_signal=pred_cell{1}(outputdim+1:end,:);

    spectrum.mix = scf * stft(mixture, nFFT ,windows, hop);
    phase_mix=angle(spectrum.mix);

    source_noise =pred_source_noise .* exp(1i.* phase_mix);
    source_signal =pred_source_signal .* exp(1i.* phase_mix);
    wavout_noise = istft(source_noise, nFFT ,windows, hop)';
    wavout_signal = istft(source_signal, nFFT ,windows, hop)';

    %% softmask
    gain=1;
    m= double(abs(pred_source_signal)./(abs(pred_source_signal)+ (gain*abs(pred_source_noise))+eps));

    source_signal =m .*spectrum.mix;
    source_noise= spectrum.mix-source_signal;

    wavout_noise = istft(source_noise, nFFT ,windows, hop)';
    wavout_signal = istft(source_signal, nFFT ,windows, hop)';

    [Parms_bss3, Other] =  BSS_3_EVAL ( s1, s2, wavout_signal, wavout_noise, mixture );

    fprintf('%s %s soft mask [TARGET]SDR:%.3f  SIR:%.3f  SAR:%.3f  NSDR:%.3f  [OTHER]SDR:%.3f  SIR:%.3f  SAR:%.3f\n', ...
        testname, stage, Parms_bss3.SDR_bss3, Parms_bss3.SIR_bss3, Parms_bss3.SAR_bss3, Parms_bss3.NSDR_bss3, Other.SDR_bss3, Other.SIR_bss3, Other.SAR_bss3);

    targets{ifile}=wavout_signal;
    
    if isfield(eI,'writewav') && eI.writewav==1
            wavwrite(wavout_noise, fs, [eI.saveDir,testname,'_iter',num2str(iter),'_softmask_noise.wav']);
            wavwrite(wavout_signal, fs, [eI.saveDir,testname,'_iter',num2str(iter),'_softmask_signal.wav']);
    end

    GSDR_bss3.soft(ifile) = Parms_bss3.SDR_bss3;
    GSIR_bss3.soft(ifile) = Parms_bss3.SIR_bss3;
    GSAR_bss3.soft(ifile) = Parms_bss3.SAR_bss3;
    Other_GSDR_bss3.soft(ifile) = Other.SDR_bss3;
    Other_GSIR_bss3.soft(ifile) = Other.SIR_bss3;
    Other_GSAR_bss3.soft(ifile) = Other.SAR_bss3;    

end

GSDR_soft_bss3 = sum(GSDR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);
GSIR_soft_bss3 = sum(GSIR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);
GSAR_soft_bss3 = sum(GSAR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);
Other_GSDR_soft_bss3 = sum(Other_GSDR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);
Other_GSIR_soft_bss3 = sum(Other_GSIR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);
Other_GSAR_soft_bss3 = sum(Other_GSAR_bss3.soft.*GSDR_bss3.len)/sum(GSDR_bss3.len);

Target_ObjectiveMeasures.GSDR=GSDR_soft_bss3;
Target_ObjectiveMeasures.GSIR=GSIR_soft_bss3;
Target_ObjectiveMeasures.GSAR=GSAR_soft_bss3;
Other_ObjectiveMeasures.GSDR=Other_GSDR_soft_bss3;
Other_ObjectiveMeasures.GSIR=Other_GSIR_soft_bss3;
Other_ObjectiveMeasures.GSAR=Other_GSAR_soft_bss3;

if strcmp(stage,'dev')
    fid_val = fopen( [eI.saveDir,'_val.txt'], 'at' );
    fprintf(fid_val, '%f, %f, %f, %f, %f, %f\n', Target_ObjectiveMeasures.GSDR,Target_ObjectiveMeasures.GSIR, ...
        Target_ObjectiveMeasures.GSAR,Other_ObjectiveMeasures.GSDR, Other_ObjectiveMeasures.GSIR, Other_ObjectiveMeasures.GSAR);
end

fprintf('\n');
fprintf('%s soft mask [TARGET]GSDR:%.3f  GSIR:%.3f  GSAR:%.3f  [OTHER]GSDR:%.3f  GSIR:%.3f  GSAR:%.3f \n',...
     stage, GSDR_soft_bss3, GSIR_soft_bss3, GSAR_soft_bss3, Other_GSDR_soft_bss3, Other_GSIR_soft_bss3, Other_GSAR_soft_bss3);
fprintf('\n');
return;

%% unit test
% (TODO) add
savedir='results';
iter=200;
modelname='model_test';
load([savedir,modelname, filesep, 'model_',num2str(iter),'.mat']);
test_mir1k_general_kl_bss3(modelname_in, theta, eI, stage, iter);
end
