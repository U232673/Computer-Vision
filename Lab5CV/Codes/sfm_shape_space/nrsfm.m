%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = nrsfm(W,MD,n_frames,n_points,test_options)
% INPUT:
% W: 2D tracking data from a monocular video [2F x P], where F is the
% number of frames "n_frames" and P is the number of points "n_points"
%
% MD: the missing data visibility matrix [F x P] - 1 if visible, 0
% if occluded
%
% test_options is a structure with:
% - K: shape basis rank
% - test_options.priors: structure with fields:
%         priors.camera_prior: boolean, 1 for rotation smoothness on, 0 off
%         priors.coeff_prior: boolean, 1 for deformation smoothness on, 0 off
%         priors.camera_weight  % penalty coefficient
%         priors.coeff_weight % penalty coefficient
%
% OUTPUT: The output structure "result" contains:
%
% result.X = X; % shape basis
% result.L = L; % weight coefficients
% result.R = R; % camera rotations
% result.T = T; % camera translations
% result.errors2d = reprojection_error; % final reprojection error
% result.rec_3D= rec_3D; % final 3D reconstruction
% result.rec_3Drigid=rec_3D_rigid; %initial 3D reconstruction



% Initialisation by rigid factorization: shape {S} and motion {R}.
% Translation can be computed as mean values of W.
T = mean(W,2);
[R,S]=rigidfactorization_ortho(W,1e-7,200); % rigid factorization (Marques-Costeira)


%Initializing low-rank shape model
X=S(:)*ones(1,test_options.K);
L=rand(test_options.K,n_frames);


%--------------------------------------------------------------------------
% Computing 2D reprojection error after applying rigid factorization
W2d_init=zeros(size(W));
for i=1:n_frames
    W2d_init(2*i-1:2*i,MD(i,:)==1)=R(2*i-1:2*i,:)*S(:,MD(i,:)==1) + repmat(T(2*i-1:2*i),1,nnz(MD(i,:)));
end
reproj_init = 100 * norm(W2d_init - W,'fro')/norm(W,'fro');
figure(1);
disp(['Initial reprojection (error: ' num2str(reproj_init) '%)'])
plot(W(1,:),W(2,:),'og') % first frame tracks
hold on
plot(W2d_init(1,:),W2d_init(2,:),'.b'); 
axis equal
legend('input data', 'initial shape','location','NorthEastOutside');
title('Observing a particular frame, before optimizing')
%--------------------------------------------------------------------------



% Properties to perform non-linear optimization and Jacobian definition
opt=optimset('Display','iter','Algorithm','levenberg-marquardt','MaxIter',50); 
opt.JacobPattern = JacobianPattern(test_options.K,n_frames,n_points,MD,test_options.priors);

% D is a [2F x P] visibility matrix, known data is W.*D. 
% Missing data visibility MD_{ij} is 1 if point j is visible in frame i, 0 for non-visible
D = zeros(2*n_frames,n_points);
D(1:2:end,:)= MD;
D(2:2:end,:)= MD;

% Vectorization of (the visible) 2D point tracks (Equations in the problem)
% In projections you have: [{x11,...xp1} {y11,...yp1} {x1f,...xpf}
% {y1f,...ypf}] where p denotes the number of points and f the number of frames
A = W'; D = D';
projections=A(D(:)==1);


% Non-linear Optimization algorithm
x0=model2vector(R,T,X,L);
f_obj = @(x)cost_RXT(x,D,projections,n_frames,n_points,test_options.K,test_options.priors);
[x_ba]=lsqnonlin(f_obj,x0,[],[],opt);


%--------------------------------------------------------------------------
% Computing reprojection error after applying a non-rigid model
[R,T,X,L] = vector2model(x_ba,n_frames,n_points,test_options.K); 
W2d_final = zeros(2*n_frames,n_points);
rec_3D = zeros(3*n_frames,n_points);
rec_3D_rigid = zeros(3*n_frames,n_points);
for f=1:n_frames

    X3d =reshape(X*L(:,f),3,n_points);
    W2d_final(2*f-1:2*f,MD(f,:)==1) =  R(2*f-1:2*f,:) * X3d(:,MD(f,:)==1)   + repmat(T(2*f-1:2*f),1,nnz(MD(f,:)));
    rec_3D(3*f-2:3*f,:) = [R(2*f-1:2*f,:);cross(R(2*f-1,:),R(2*f,:))]* X3d;
    rec_3D_rigid(3*f-2:3*f,:) = S;
    
end
reprojection_error = norm((W2d_final - W), 'fro')/norm(W, 'fro');
figure(2);
disp(['Final reprojection (error: ' num2str(reprojection_error) '%)'])
plot(W(1,:),W(2,:),'og') % first frame tracks
hold on
plot(W2d_final(1,:),W2d_final(2,:),'.b'); 
axis equal
legend('input data', 'initial shape','location','NorthEastOutside');
title('Observing a particular frame, after optimizing')
%--------------------------------------------------------------------------


% Statistics
result.X = X; % shape basis
result.L = L; % weight coefficients
result.R = R; % camera rotations
result.T = T; % camera translations
result.errors2d = reprojection_error; % final reprojection error
result.rec_3D= rec_3D; % final 3D reconstruction
result.rec_3Drigid=rec_3D_rigid; %initial 3D reconstruction
end

