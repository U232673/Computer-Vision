%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function v = model2vector(R,T,X,L)
% INPUT:
% R: camera rotations [2F X 3]
% T: camera translations [2F X 1]
% X: shape vectors [3P X K]
% L: weight coefficients [K X F]
%
% OUTPUT: 
%
% v: a vector with all parameters you should estimate, following the order
% [{L_11, ..., L_K1, R_1 T_1} ... {L_1F, ..., L_KF, R_F T_F}, X_1, ..., X_K]
% i.e., for every frame until F, to include weight coefficients rotations
% (4 entries, quaternions) and translations (2 entries), and finally, the K shape vectors


n_frames = size(R,1)/2;
n_points = size(X,1)/3;
K = size(L,1);

% From rot [2 x 3] to rot [3 x 3]
Rot=zeros(3*n_frames,3);
for f=1:n_frames
    Rot(3*f-2:3*f,:) = [ R(2*f-1:2*f,:); cross(R(2*f-1,:),R(2*f,:))];
end

%% Make vector v contains L,R,T_{frame1}, ..., L,R,T_{frameF}...
v=zeros((K+6)*n_frames+3*n_points*K,1);
idx = 1;
for f=1:n_frames
    
    v(idx:idx+K-1) = L(:,f);
    v(idx+K:idx+K+3) = rot2quat(Rot(3*f-2:3*f,:));  % quaternions
    v(idx+K+4:idx+K+5) = T(2*f-1:2*f);
    idx = idx + K +6;
end

%% Make vector v contains X_{vector1}, ..., X_{vectorK}
for k=1:K
    v(idx:idx+3*n_points-1)=X(:,k);
    idx=idx+3*n_points;
end


end