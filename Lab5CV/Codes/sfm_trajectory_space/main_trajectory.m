%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

warning('off','all')
addpath ..\data


%--------------------------------------------------------------------------
b = input('Checking sequence drink (D), yoga (Y), stretch (S), pickup (P), dance (C) or dinosaur (W) \n','s');
if (b=='d' || b=='D' || b=='y' || b=='Y' || b=='s' || b=='S' || b=='p' || b=='P')
    a=1; % Ground truth on shape and motion
else
    a=0; % Ground truth on shape
end

%--------------------------------------------------------------------------
% LOAD DATA
if (b=='d' || b=='D') % synthetic data with 3D ground truth
    load 'drink_mocap.mat' 
elseif (b=='y' || b=='Y')
    load 'yoga_mocap.mat' 
elseif (b=='s' || b=='S')
    load 'stretch_mocap.mat' 
elseif (b=='p' || b=='P')
    load 'pickup_mocap.mat' 
elseif (b=='c' || b=='D')
    load 'dance_mocap.mat' 
elseif (b=='w' || b=='W')
    load 'dinosaur_real.mat';
else
    error('No dataset was selected...');
end
%--------------------------------------------------------------------------



% Rank of the trajectory basis
K = 11;


% Run the NRSfM method
[rec_3D, R_est] = nrsfm_trajectory(W, K);


% Evaluation
if (a==1)
    errS = compareStructs(GT.shape3D, rec_3D);
    disp(['3D error: ' num2str(mean(errS))])
    errR = compareRotations(GT.R, R_est);
    disp(['3D error: ' num2str(mean(errR))])
    viewStruct(GT.shape3D, rec_3D)
else
    [rec_3D] = rotateStruct(rec_3D, R_est);
    errS = compareStructs(GT.shape3D, rec_3D);
    disp(['3D error: ' num2str(mean(errS))])
    viewStruct(GT.shape3D, rec_3D)
end


