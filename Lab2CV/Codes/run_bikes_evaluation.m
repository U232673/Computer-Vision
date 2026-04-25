clear; close all;
addpath('Lowe_SIFT');
addpath('lib');

% Define the folder and base image
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
    
    % Load images for transformation
    im1 = imread(img1_path);
    H_gt = load(gt_path);
    
    % Apply transformations using imTrans
    im_warped_est = imTrans(im1, H_est);
    im_warped_gt = imTrans(im1, H_gt);
    
    % Show side-by-side comparison
    figure;
    subplot(1,2,1); imshow(im_warped_est); 
    title(['Est. H (Img 1 to ', num2str(i), ') - Error: ', num2str(err, '%.4f')]);
    subplot(1,2,2); imshow(im_warped_gt); 
    title(['Ground Truth H (Img 1 to ', num2str(i), ')']);
    
    fprintf('Error for Image 1 to %d: %f\n', i, err);
end

% Display all errors for the final report discussion
disp('Summary of Errors for Bikes folder:');
disp(errors);

% Visualize the errors
figure;
h = bar(1:5, errors);
xlabel('Image Pair (Img 1 to Img N)');
ylabel('Error');
title('Summary of Homography Estimation Errors - Bikes Dataset');
xticks(1:5);
xticklabels({'Img 1-2', 'Img 1-3', 'Img 1-4', 'Img 1-5', 'Img 1-6'});
grid on;
% Add error values on top of each bar
for j = 1:5
    text(j, errors(j), sprintf('%.4f', errors(j)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end