%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function errS = compareStructs(S, Shat)

s = mean(std(S, 1, 2));
S = S/s;
sm = mean(S,2);
S = S - sm*ones(1,size(S,2));

Shat = Shat/s;
F = size(S,1)/3;
P = size(S,2);

% Procrust Alignment
Y = findRotation(S, Shat);        
for i=1:F
    Shat(3*i-2:3*i,:) = Y*Shat(3*i-2:3*i,:);
    errS(i)  = sum(sqrt( sum( (S(3*i-2:3*i, :)-Shat(3*i-2:3*i, :)).^2) ) )/P;
end
