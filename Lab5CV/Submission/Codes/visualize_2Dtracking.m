%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is to visualize 2D point trajectories from a monocular video
%

clear all 
clc
close all



addpath data\Dinosaur
addpath data

load 'dinosaur_real.mat' W


figure(401)
for i = 1:size(W,1)/2
   i
   im=imread(sprintf('%03d.bmp',i));
   imshow(im);
   hold on
   plot(W(2*i-1,:),W(2*i,:),'oc','LineWidth',2,'MarkerSize',10); 
   hold off
   pause(.1)
   
end