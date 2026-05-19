%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f] = evalQ(q,LambdaH)

Rbar = LambdaH*q;       

Rbar1 = Rbar(1:2:end, :);
Rbar2 = Rbar(2:2:end, :);

onesArr = [ sum(Rbar1.^2, 2); sum(Rbar2.^2, 2)];
zerosArr = sum(Rbar1.*Rbar2, 2);

f = sum( (onesArr-1).^2 ) + sum(zerosArr.^2);