%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY 1
%%%              COMPUTER VISION 2025-2026
%%%              SIFT features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc


addpath('../lib/');
addpath('../data/');

% INPUT DATA: reading a picture
I = imread('textureless-b.jpg');

% let's only work in the gray scale. 
[a,b,c] = size(I);
if c == 3
	I = 0.2989*I(:,:,1)+ 0.587*I(:,:,2)+0.114*I(:,:,3);
end


% make I to be an image with data type double precision
I = double(I);

% get the height and the width of the input image
[M,N] = size(I);


% PARAMETER TUNING: setup some parameters based on Lowe's choices
params.S=3 ; % nb of scales per octave
params.omin=-1 ; % min octave, if it is negative, then we double the image
params.O=floor(log2(min(M,N)))-params.omin-4 ; % total nb of octave, Up to 16x16 images
params.sigma0=1.6*2^(1/params.S) ; % initial sigma
params.sigman=0.5 ; % assumed blur of the input image
params.smin  = -1 ;
params.smax  = params.S +1;


% build the scale space for the input image
pyramid= scale_space(I, params);

% then compute the Difference of the Gaussian
DOG = difference_of_gaussians(pyramid, params);

% finally find points that are extremas in the DOG
params.thresh = 0.8 * (0.04 / params.S / 2 );
keypoints = find_extremas(DOG, params);


% unite the keypoints to one scale
figure(1)
hold on
%set(gcf,'colormap',gray);
imdisp(uint8(I));

%truesize;
axis off
%imshow(uint8(I));



for y = 1:M
    for x = 1:N
        if keypoints(y,x) > 0
            plot(x,y,'x','MarkerSize',5)    
        end
     end
end


% To plot just the key-points
figure(2)
spy(keypoints)
