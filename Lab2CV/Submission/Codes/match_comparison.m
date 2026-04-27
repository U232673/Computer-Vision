%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY 2
%%%              COMPUTER VISION 2025-2026
%%%              FEATURE DETECTION AND DESCRIPTION. MATCHING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clc
close all

addpath data_set

% Load input image
image=imread('sunflower.jpg');   %   <---- You can use your own data

if (size(image,3))
    image=rgb2gray(image);
end

% Define parameter ranges
scales = 1.2:0.4:2;          % [1.2, 1.6, 2.0]
rotations = -60:20:60;       % [-60, -40, -20, 0, 20, 40, 60]

% Descriptors
descriptors = {'FAST', 'SIFT', 'SURF', 'KAZE', 'BRISK', 'ORB', 'HARRIS', 'MSER'};
num_descriptors = length(descriptors);
num_scales = length(scales);
num_rotations = length(rotations);
num_combinations = num_scales * num_rotations;

% Storage for results
results = struct();
for i = 1:num_descriptors
    results.(descriptors{i}).num_matches = zeros(num_scales, num_rotations);
    results.(descriptors{i}).comp_time = zeros(num_scales, num_rotations);
end

% Process all combinations
disp('Processing all scale and rotation combinations...');
combination_idx = 1;

for s_idx = 1:num_scales
    scale = scales(s_idx);
    for r_idx = 1:num_rotations
        rotation = rotations(r_idx);
        
        % Generate synthetic image
        image2 = imrotate(imresize(image,scale),rotation);
        
        % Process each descriptor
        for d_idx = 1:num_descriptors
            descriptor_type = descriptors{d_idx};
            
            % Detect features based on descriptor type
            switch descriptor_type
                case 'FAST'
                    pts1 = detectFASTFeatures(image);
                    pts2 = detectFASTFeatures(image2);
                case 'SIFT'
                    pts1 = detectSIFTFeatures(image);
                    pts2 = detectSIFTFeatures(image2);
                case 'SURF'
                    pts1 = detectSURFFeatures(image);
                    pts2 = detectSURFFeatures(image2);
                case 'KAZE'
                    pts1 = detectKAZEFeatures(image);
                    pts2 = detectKAZEFeatures(image2);
                case 'BRISK'
                    pts1 = detectBRISKFeatures(image);
                    pts2 = detectBRISKFeatures(image2);
                case 'ORB'
                    pts1 = detectORBFeatures(image);
                    pts2 = detectORBFeatures(image2);
                case 'HARRIS'
                    pts1 = detectHarrisFeatures(image);
                    pts2 = detectHarrisFeatures(image2);
                case 'MSER'
                    pts1 = detectMSERFeatures(image);
                    pts2 = detectMSERFeatures(image2);
            end
            
            tic
            % Feature extraction and matching
            [features1, validPts1] = extractFeatures(image, pts1);
            [features2, validPts2] = extractFeatures(image2, pts2);
            
            num_inliers = 0;
            
            try
                if size(features1,1) > 0 && size(features2,1) > 0
                    indexPairs = matchFeatures(features1, features2);
                    if size(indexPairs, 1) >= 4  % Need at least 4 points for similarity transform
                        matched1 = validPts1(indexPairs(:,1));
                        matched2 = validPts2(indexPairs(:,2));
                        % Removing outliers
                        [tform, inlierIdx] = estimateGeometricTransform2D(matched2, matched1, 'similarity');
                        num_inliers = sum(inlierIdx);
                    end
                end
            catch ME
                % If transformation estimation fails, keep num_inliers = 0
                num_inliers = 0;
            end
            comp_time = toc;
            
            % Store results
            results.(descriptor_type).num_matches(s_idx, r_idx) = num_inliers;
            results.(descriptor_type).comp_time(s_idx, r_idx) = comp_time;
        end
        
        disp(['Processed combination ' num2str(combination_idx) ' / ' num2str(num_combinations) ...
              ': Scale=' num2str(scale) ', Rotation=' num2str(rotation) '°']);
        combination_idx = combination_idx + 1;
    end
end

% Visualize results
disp(' ');
disp('RESULTS SUMMARY');
for d_idx = 1:num_descriptors
    descriptor_type = descriptors{d_idx};
    avg_matches = mean(results.(descriptor_type).num_matches(:));
    avg_time = mean(results.(descriptor_type).comp_time(:));
    disp(['Descriptor: ' descriptor_type ...
          ' | Avg Matches: ' num2str(avg_matches, '%.1f') ...
          ' | Avg Time: ' num2str(avg_time, '%.4f') 's']);
end

% Create comprehensive visualization
% Figure 1: Number of Matches
figure('Position', [100, 100, 1400, 900])

for d_idx = 1:num_descriptors
    subplot(2, 4, d_idx)
    
    descriptor_type = descriptors{d_idx};
    data = results.(descriptor_type).num_matches;
    
    % Create heatmap
    imagesc(data)
    colorbar
    set(gca, 'XTick', 1:num_rotations, 'XTickLabel', rotations)
    set(gca, 'YTick', 1:num_scales, 'YTickLabel', scales)
    xlabel('Rotation (degrees)')
    ylabel('Scale Factor')
    title([descriptor_type ' - Number of Matches'])
    
    % Add text annotations for matches
    hold on
    for s_idx = 1:num_scales
        for r_idx = 1:num_rotations
            num_matches = data(s_idx, r_idx);
            text(r_idx, s_idx, num2str(num_matches), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'FontSize', 9, 'Color', 'white', 'FontWeight', 'bold')
        end
    end
    hold off
end

sgtitle('Feature Matching Comparison: Number of Matches')

% Figure 2: Computation Time
figure('Position', [100, 100, 1400, 900])

for d_idx = 1:num_descriptors
    subplot(2, 4, d_idx)
    
    descriptor_type = descriptors{d_idx};
    data = results.(descriptor_type).comp_time;
    
    % Create heatmap
    imagesc(data)
    colorbar
    set(gca, 'XTick', 1:num_rotations, 'XTickLabel', rotations)
    set(gca, 'YTick', 1:num_scales, 'YTickLabel', scales)
    xlabel('Rotation (degrees)')
    ylabel('Scale Factor')
    title([descriptor_type ' - Computation Time (s)'])
    
    % Add text annotations for computation time
    hold on
    for s_idx = 1:num_scales
        for r_idx = 1:num_rotations
            comp_time = data(s_idx, r_idx);
            text(r_idx, s_idx, sprintf('%.2f', comp_time), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'FontSize', 9, 'Color', 'white', 'FontWeight', 'bold')
        end
    end
    hold off
end

sgtitle('Feature Matching Comparison: Computation Time (seconds)')


