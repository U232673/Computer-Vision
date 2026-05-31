%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%hint: to create vector of quaternion and rotations:
%qt=[]; for f=1:F qt=[qt rot2quat(GT.rot(3*f-2:3*f,:)) GT.TR(3*f-2:3*f-1)];
%end;
function q = rot2quat(r)
q=zeros(1,4);
q(1) = (1/2) * sqrt(r(1,1) + r(2,2) + r(3,3) +1 );
q(2) = (1/2) * sign(r(3,2) - r(2,3)) * sqrt(r(1,1) - r(2,2) - r(3,3) +1);
q(3) = (1/2) * sign(r(1,3) - r(3,1)) * sqrt(r(2,2) - r(3,3) - r(1,1) +1);
q(4) = (1/2) * sign(r(2,1) - r(1,2)) * sqrt(r(3,3) - r(1,1) - r(2,2) +1);
if ~isreal(q)
    warning('imaginary in quaternion')
    keyboard
end
end