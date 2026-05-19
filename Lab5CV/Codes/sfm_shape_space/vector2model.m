%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [R,T,X,L] = vector2model(v,n_frames,n_points,K)
% INPUT: 
%
% v: a vector with all parameters you should estimate, following the order
% [{L_11, ..., L_K1, R_1 T_1} ... {L_1F, ..., L_KF, R_F T_F}, X_1, ..., X_K]
% i.e., for every frame until F, to include weight coefficients rotations
% and translations, and finally, the K shape vectors
%
% OUTPUT:
% R: camera rotations [2F X 3]
% T: camera translations [2F X 1]
% X: shape vectors [3P X K]
% L: weight coefficients [K X F]



R = zeros(2*n_frames,3);
T = zeros(2*n_frames,1);
X = zeros(3*n_points, K);
L = zeros(K, n_frames);


idx=1;
for f=1:n_frames
    L(:,f) = v(idx:idx+K-1);
    q=v(idx+K:idx+K+3);
    q=q/norm(q); % Normalization
    r3by3 = quat2rot(q);
    R(2*f-1:2*f,:) = r3by3(1:2,:);
    T(2*f-1:2*f) = v(idx+K+4:idx+K+5);
    idx = idx + 6 + K;
end

for k=1:K
    X(:,k)=v(idx:idx+3*n_points-1);
    idx=idx+3*n_points;
end



end

