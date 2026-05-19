%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = DCT_basis(f, k)
% OUTPUT: DCT based trajectory basis

%Generate DCT matrix of required size
d = idct(eye(f));

%truncate values not required
d = d(:, 1:k);

%rearrange into theta matrix
out = [];

for i = 1:f
    out = [out; [d(i,:) zeros(1,2*k); zeros(1,k) d(i,:) zeros(1,k); zeros(1,2*k) d(i,:)]];
end;
