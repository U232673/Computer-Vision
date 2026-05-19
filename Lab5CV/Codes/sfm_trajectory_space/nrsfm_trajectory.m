%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, Rsh] = nrsfm_trajectory(W, K)
% INPUT:
% W: 2D tracking data [2F X P]
% K: number of DCT basis
%
% OUTPUT: 
%
% X: recovered non-rigid structure
% Rsh: recovered rotations


disp('Computing...')


n_frames = size(W,1)/2;
n_points = size(W,2);


% Removing the translation part
T = mean(W,2);
W = W - T*ones(1,size(W,2));



    %%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% MISSING CODE HERE %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % You need the motion "RHat" and shape ""Xhat"" factors without assuming the corrective
    % matrix Q (this step is provided later)
    %RHat=;
    %Xhat=;


%-------------------------------------------------------------------------

% Metric Upgrade step
[Q] = metricUpgrade(RHat);
Rsh = RHat*Q;

% Computing final motion and shape
R = recoverR(Rsh);
C = DCT_basis(n_frames,K);
G = R*C;
D = inv(G'*G)*G'*W;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% MISSING CODE HERE %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the final time-varying shape, X
    %X=;
