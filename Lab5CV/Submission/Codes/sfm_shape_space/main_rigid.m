%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
close all
clc

addpath ..\data

load 'ogre_synthetic.mat'

% Data
n_frames=size(W,1)/2;
n_points=size(W,2);

% Observing the input data
for f=1:n_frames
    plot(W(2*f-1,:),W(2*f,:),'.r');
    axis equal
    title('Input 2D point tracks')
    pause(.2)

end



% Run Rigid Factorization to compute rigid shape S and motion R
disp('Running...')
[R,S]=rigidfactorization_ortho(W,1e-7,200); 



%--------------------------------------------------------------------------
% Evaluation, and comparison with respect to ground truth
[val,our3D,gt3D] = check_multiple_shapes(S,GT.shape3D);
disp(['3D error: ' num2str(mean(val)*100) ' % '])

figure(2)
plot3(our3D(1,:),our3D(2,:),our3D(3,:),'.b')
hold on
plot3(gt3D(1,:),gt3D(2,:),gt3D(3,:),'og')
hold off
axis equal
legend('3D Reconstruction','3D Ground truth','location','NorthEastOutside');
view(29,50)
xlabel('x')   
ylabel('y')  
zlabel('z')  
%--------------------------------------------------------------------------



% Joint visualization of shape and motion
figure(3)
for f=1:n_frames
    rec_3D = [R(2*f-1:2*f,:);cross(R(2*f-1,:),R(2*f,:))]* S;
    plot3(rec_3D(1,:),rec_3D(2,:),rec_3D(3,:),'.r')
    axis equal
    title('Output 3D Reconstruction')
    view(1,70)
    xlabel('x')   
    ylabel('y')  
    zlabel('z')  
    pause(.2)
end









