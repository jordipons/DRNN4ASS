function run_test_single_model

    tStart = tic;

    % Dependencies
    addpath(['codes']);
    addpath(['tools', filesep,'bss_eval_3']);
    addpath(['tools', filesep,'labrosa']);
    addpath(['codes', filesep,'mir1k']);

    % Load model
    %name_model='VOICE_model_1960';
    name_model='model_400';
    ModelPath=['models/1st Models', filesep, name_model,'.mat'];
    load([ModelPath]);
    
    % Waves path?
    dataset_name='TestVocals';
    eI.DataPath=['../', 'waves', filesep, dataset_name];
    
    % Save audios?
    eI.writewav=0;
    eI.saveDir = ['resultWaves/',name_model,'_',dataset_name,'_'];
    
    fprintf('-------\n \nMODEL: %s \n',ModelPath);
    
    [targets,Target_ObjectiveMeasures,Other_ObjectiveMeasures] = test_mir1k_general_kl_bss3(eI.modelname, theta, eI, 'testall', info.iteration);
        
    tEnd = toc(tStart);
    fprintf('%d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
    Target_ObjectiveMeasures
    Other_ObjectiveMeasures

    fprintf('-------\n');
end
