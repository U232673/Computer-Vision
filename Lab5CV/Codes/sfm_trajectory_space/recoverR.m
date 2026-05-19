%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R] = recoverR(Rs)
% INPUT: Rs [2n_frames x3] rotation matrix
% OUTPUT: R block-diagonal [2n_frames x3n_frames] rotation matrix

for i = 1:size(Rs,1)/2
    R(2*(i-1)+1:2*(i-1)+2,3*(i-1)+1:3*(i-1)+3) = Rs(2*(i-1)+1:2*(i-1)+2,:);
end