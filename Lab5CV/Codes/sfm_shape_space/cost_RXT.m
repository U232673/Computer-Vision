%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [err] = cost_RXT(v,MD,x,n_frames,n_points,K,priors)
% INPUT:
% v: vector including the parameters you are estimating
% MD: visibility matrix per coordinate
% x: vectorization with 2D tracking data
% priors: structure with fields:
%         priors.camera_prior: boolean, 1 for rotation smoothness on, 0 off
%         priors.coeff_prior: boolean, 1 for deformation smoothness on, 0 off
%         priors.camera_weight  % penalty coefficient
%         priors.coeff_weight % penalty coefficient
% OUTPUT:
% err: errors in the energy function


% parameter vectors v contains U,R,T_{frame1} , U,R,T_{frame2}...
[R,T,X,L] = vector2model(v,n_frames,n_points,K);

W2d = zeros(2*n_frames,n_points);
for f=1:n_frames
    W2d(2*f-1:2*f,:) = R(2*f-1:2*f,:) * reshape(X*L(:,f),3,n_points)   + repmat(T(2*f-1:2*f),1,n_points);
end
W2d = W2d';
% Data Term
err = W2d(MD(:)==1) - x; 


% Deformation smoothness priors
if (priors.coeff_prior == 1)
    prior = zeros(n_frames-1,1);
    for f=1:n_frames-1
        prior(f) = norm(L(:,f) - L(:,f+1),'fro'); 
    end

    err = [err;priors.coeff_weight*prior]; 
end

% Rotation smoothness priors
if (priors.camera_prior == 1)
    prior = zeros(n_frames-1,1);
    for f=1:n_frames-1
        prior(f) = norm(R(2*f-1:2*f,:) - R(2*(f+1)-1:2*(f+1),:),'fro')/...
            norm (R(2*f-1:2*f,:),'fro' ); 
    end
    err = [err;priors.camera_weight*prior];
end

end
