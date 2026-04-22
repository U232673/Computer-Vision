% Clean up environment
clear; close all;
addpath('Lowe_SIFT');
addpath('lib');

% Define the folder and base image [cite: 41]
folder = 'data_set/bikes/';
img1_path = [folder, 'img1.ppm'];

% Results storage
errors = zeros(1, 5);

for i = 2:6
    imgi_path = [folder, sprintf('img%d.ppm', i)];
    gt_path = [folder, sprintf('H1to%dp', i)];
    
    % Call our custom function
    [H_est, err] = estimate_h(img1_path, imgi_path, gt_path);
    errors(i-1) = err;
    
    % Load images for transformation [cite: 55, 56]
    im1 = imread(img1_path);
    H_gt = load(gt_path);
    
    % Apply transformations using imTrans [cite: 55, 56]
    im_warped_est = imTrans(im1, H_est);
    im_warped_gt = imTrans(im1, H_gt);
    
    % Show side-by-side comparison for the report [cite: 57, 58]
    figure;
    subplot(1,2,1); imshow(im_warped_est); 
    title(['Est. H (Img 1 to ', num2str(i), ')']);
    subplot(1,2,2); imshow(im_warped_gt); 
    title('Ground Truth H');
    
    fprintf('Error for Image 1 to %d: %f\n', i, err);
end

% Display all errors for the final report discussion [cite: 61]
disp('Summary of Errors for Bikes folder:');
disp(errors);