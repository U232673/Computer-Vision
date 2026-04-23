function [H, error] = estimate_h(im1_path, im2_path, GT_H_path)
    % Save the original directory to return later
    originalDir = pwd;
    
    % Ensure the paths are absolute so they work after we 'cd'
    im1_full = fullfile(originalDir, im1_path);
    im2_full = fullfile(originalDir, im2_path);
    gt_full = fullfile(originalDir, GT_H_path);

    try
        % Move to the SIFT directory to run the binary
        cd('Lowe_SIFT');
        
        % Use the provided match.m logic to get features and matches
        % This function internally calls sift.m and applies the 0.6 ratio
        [~, loc1, ~, loc2, matchings, ~] = match(im1_full, im2_full);
        
        % Format points for RANSAC using the provided helper
        [pts1, pts2] = get_matching_pts(loc1, loc2, matchings);
        
        % Return to main folder to access 'lib' functions
        cd(originalDir);
        addpath('lib');
        
        % Apply RANSAC to estimate Homography [cite: 50]
        % 1.0 is the pixel threshold for inliers
        [H, ~] = ransacfithomography(pts1, pts2, 1.0);
        
        % Calculate Error with respect to Ground Truth [cite: 51]
        GT_H = load(gt_full, '-ascii');

        % Normalize Estimated H
        if H(3,3) ~= 0
            H = H ./ H(3,3);
        end
        
        % Normalize Ground Truth H
        if GT_H(3,3) ~= 0
            GT_H = GT_H ./ GT_H(3,3);
        end
        
        % Now calculate the Frobenius norm error
        error = norm(H - GT_H);
        
    catch ME
        % If an error occurs, ensure we return to the starting directory
        cd(originalDir);
        rethrow(ME);
    end
end