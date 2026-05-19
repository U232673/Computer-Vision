%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
close all
clc

addpath ..\data


%--------------------------------------------------------------------------
b = input('Checking synthetic S or real R experiment S/R \n','s');
if b=='r' || b=='R'
    a=0;
else
    a=1;
end

%--------------------------------------------------------------------------
% LOAD DATA. a=1 for synthetic experiment, otherwise for real one
if (a==1) % synthetic data with 3D ground truth
    load face_mocap.mat
else     % real data, only 2D point tracks
    load 'face_real.mat'
end
%--------------------------------------------------------------------------


%----------------------------------  Tuning  ------------------------------
% Rank of the shape basis
test_options.K= 2;
% Including temporal priors, Binary entry: '1' on, '0' off
test_options.priors.camera_prior = 0; % rotation smoothness prior
test_options.priors.coeff_prior = 0; % deformation coefficients smoothness prior
% Penalty coefficients
test_options.priors.camera_weight = 0.03; % rotation smoothness prior
test_options.priors.coeff_weight = 0.4; % deformation smoothness prior
if (test_options.priors.camera_prior == 0 || test_options.priors.camera_prior == 1 || test_options.priors.coeff_prior == 0 || test_options.priors.coeff_prior == 1)
    ;
else
    error('A binary entry is needed to encode priors...');
end
%--------------------------------------------------------------------------


% Obtaining general values
n_frames = size(W,1)/2;
n_points = size(W,2);

% Observability matrix to define missing data: ones denote visibility
MD = ones(n_frames,n_points); 

% Run the NRSfM method
disp('Running...')
result = nrsfm(W,MD,n_frames,n_points,test_options);
rec_3D = result.rec_3D;
rec_3D_rigid = result.rec_3Drigid;

% Visualization
%--------------------------------------------------------------------------
if (a==1)
    
    [valR] = check_multiple_shapes(rec_3D_rigid,GT.shape3D);
    disp(['3D error by assuming a rigid model: ' num2str(mean(valR)*100) ' % '])
    
    [val,our3D,gt3D] = check_multiple_shapes(rec_3D,GT.shape3D);
    disp(['3D error by assuming a non-rigid model: ' num2str(mean(val)*100) ' % '])
    visualise(W,gt3D,our3D)
    
else
    figure(100)
    for f=1:n_frames
        plot3(rec_3D(3*f-2,:),rec_3D(3*f-1,:),rec_3D(3*f,:),'.r')
        axis equal
        view(138,44)
        pause(.2)
    end
end
%--------------------------------------------------------------------------






