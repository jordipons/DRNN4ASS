warning('off')
%rng('shuffle') % uncomment for NON-deterministic randomness
randn(1,5)

runID='ID';

% arquitecture
hidden_units = 1000;
num_layers = 3;
isRNN = 2;

temporalInit='eye'; % 'xavierSmall', 'zero', 'he' and 'eye'.
temporalInitParam=1; % factor applied to the recurrent factor. Set to one if you don't know.
hiddenInit='he'; % 'xavier' and 'he'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
act = 2;    % 0: logistic, 1: tanh, 2: RELU

% context window size
context_win = 3;

% 0: MFCC, 1: logmel, 2: spectra
MFCCorlogMelorSpectrum = 2;
% feature frame rate: winsize = 1024;nFFT = 1024;hop=eI.winsize/2; (64)
framerate = 64;

target='Vocals';
train_data_path=['../waves/Train',target,filesep];
val_data_path=['../waves/Val',target,filesep];
train_files= dir( [train_data_path,'*wav'] );
val_files= dir( [val_data_path,'*wav'] );

% normalize input data
norm_data=1;

% cut beggining and end silences.
cut_silences=0;

% discriminative training gamma parameter
pos_neg_r = 0.05;

% output layer - linear (0) or nonlinear (1)
outputnonlinear = 0;

% one output source (1) or two sources (0)
iscleanonly = 0;

% Circular shift step
circular_step = Inf;

% regularization dropout
isdropout = 0;

% normalize input as L1 norm = 1
isinputL1 = 0;

% constants for avoiding numerical problems
const = 1e-10;
const2 = 0.001;

% 0: not using GPU, 1: using GPU
isGPU = 0;

% TRAIN MODE % how formulate data % 0: Training (noisy data and clean data)
% 1: Testing (just noisy data) % 2: Error testing (both witout chunking)
train_mode = 0;

% OPT % 0:'softlinear',1:'softabs', 2:'softquad', 3:'softabs_const',
% 4:'softabs_kl_const' %%% THIS IS THE KIND OF MASK!
opt = 1; % abs(a1)./(abs(a1)+abs(a2)+1e-10).* mixture

codeDir = ['codes', filesep];
addpath([codeDir,'mir1k']);

train_mir1k_demo(context_win, hidden_units, num_layers, isdropout, ...
    isRNN, iscleanonly, circular_step , isinputL1, MFCCorlogMelorSpectrum, ...
    framerate, pos_neg_r, outputnonlinear, opt, act, train_mode, const,  ...
    const2, isGPU, train_files, train_data_path, val_files, val_data_path, ...
    cut_silences, runID, norm_data, hiddenInit, temporalInit, temporalInitParam)
