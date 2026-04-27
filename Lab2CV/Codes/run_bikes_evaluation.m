% Clean up environment
clear; close all; clc;
addpath('Lowe_SIFT');
addpath('lib');

% List of folders to process
datasets = {'leuven', 'graf', 'boat', 'bikes'};
base_path = 'data_set/'; % Adjust this to where your folders actually live

for d = 1:length(datasets)
    current_dataset = datasets{d};
    folder = [base_path, current_dataset, '/'];
    
    fprintf('\n--- Processing Dataset: %s ---\n', upper(current_dataset));
    
    img1_path = [folder, 'img1.ppm'];
    errors = zeros(1, 5);
    
    for i = 2:6
        imgi_path = [folder, sprintf('img%d.ppm', i)];
        % Note: Ensure file names match (e.g., H1to2p or H1to2.txt)
        gt_path = [folder, sprintf('H1to%dp', i)];
        
        try
            % 1. Estimate Homography
            [H_est, err] = estimate_h(img1_path, imgi_path, gt_path);
            errors(i-1) = err;
            
            % 2. Load images and Ground Truth for visualization
            im1 = imread(img1_path);
            H_gt = load(gt_path, '-ascii'); % Force ascii load for stability
            
            % 3. Apply transformations
            im_warped_est = imTrans(im1, H_est);
            im_warped_gt = imTrans(im1, H_gt);
            
            % 4. Visualization
            fig = figure('Name', [current_dataset, ' Pair 1-', num2str(i)], 'NumberTitle', 'off');
            subplot(1,2,1); imshow(im_warped_est); 
            title(['Est. H (1 to ', num2str(i), ')']);
            subplot(1,2,2); imshow(im_warped_gt); 
            title('Ground Truth H');
            
            % Optional: Save the comparison images automatically
            % saveas(fig, ['Figures/', current_dataset, '_pair1_', num2str(i), '.jpg']);
            
            fprintf('  Image 1 to %d Error: %.4f\n', i, err);
            
        catch ME
            fprintf('  Error processing %s pair 1-%d: %s\n', current_dataset, i, ME.message);
            errors(i-1) = NaN;
        end
    end
    
    % Summary for the current dataset
    fprintf('Final Errors for %s: ', current_dataset);
    disp(errors);
end
