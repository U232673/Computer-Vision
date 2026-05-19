%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [J]=JacobianPattern(K,n_frames,n_points,vij,priors)
% Input
% K: shape basis rank
% n_frames: number of frames 
% n_points: number of points 
% vij: visibility map
% - priors: structure with fields:
%         priors.camera_prior: boolean, 1 for rotation smoothness on, 0 off
%         priors.coeff_prior: boolean, 1 for deformation smoothness on, 0 off 
% Output
% J: the Jacobian matrix pattern
 
 
 
 
% J data term is shorter than 2xFxP if the FxP visibility contains zeros
prior_terms = priors.coeff_prior + priors.camera_prior;


% Prior_terms must be a number from 0 to 2
if prior_terms < 0 || prior_terms > 2
    error('wrong values in prior options');
end

% Jacobian matrix pattern definition
% I give you the size, but you need to define the "ones"
J = sparse(2*nnz(vij)+ prior_terms*(n_frames-1),(K+6)*n_frames + K*3*n_points);
 

 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% MISSING CODE HERE %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % You need to include the correct relations in J. First of all, consider the data term, and then, the priors
    
     % Data term
     %
    
 if (priors.coeff_prior == 1)
     % prior terms on L

 end
 
 if (priors.camera_prior == 1)
     % prior terms on rotations

 end
 
 

% % You can see easily the Jacobian pattern using the command spy(J)
%  disp('Observe the Jacobian pattern...')
%  spy(J)
