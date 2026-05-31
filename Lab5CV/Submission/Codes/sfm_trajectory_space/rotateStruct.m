%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Shat] = rotateStruct(Sh, Rs)

n_frames = size(Rs,1)/2;

for i=1:n_frames
    Y1 = Rs(2*i-1:2*i, :);
    Y1(3, :) = cross(Y1(1,:), Y1(2,:));
    Y2 = [Y1(1:2, :); -Y1(3,:)];
    if det(Y1)>0
        Y = Y1;
    else
        Y = Y2;
    end;
    Shat(3*i-2:3*i, :) = Y*Sh(3*i-2:3*i, :);
end;
