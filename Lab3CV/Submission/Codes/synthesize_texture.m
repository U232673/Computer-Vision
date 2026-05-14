%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #3 
%%%              COMPUTER VISION 2025-2026
%%%              Exemplar-based methods and applications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [texture, copy_map] = synthesize_texture(sample, texture_size, patch_size, tolerance)
%synthesize_texture Creates a new texture of a given size using a given
%                   sample
%	sample - input image from which a new texture is built
%   texture_size - desired size of a new texture image
%   patch_size - size of the square patch to be used
%   tolerance - threshold that controls amount of similar patches (0; 1)

    seed_size = [3 3];
    sample_size = size(sample);
    patch_half = floor(patch_size / 2);

    % Check sample size
    if sample_size(1) < seed_size(1) || sample_size(2) < seed_size(2)
        error('Sample is too small.');
    end
    
    % Create buffers
    color_map = build_color_map([sample_size(1), sample_size(2)]);
    texture = uint8(zeros([texture_size(1) texture_size(2) size(sample, 3)]));
    copy_map = uint8(zeros([texture_size(1) texture_size(2) size(color_map,3)]));
    mask = zeros([texture_size(1) texture_size(2)]);
    
    % Precompute Gaussian intra-patch weights
    weights = gaussian_kernel_2d(patch_size);
    
    % Extract patches
    [patch_list, coordinates] = extract_patches(sample, [patch_size patch_size]);
    patch_list = single(patch_list);
    
    % Take seed at random from the sample
    seed_pos = [round(rand(1) * (sample_size(1) - seed_size(1))) + 1, ...
                round(rand(1) * (sample_size(2) - seed_size(2))) + 1];

    % Paste seed in the center of texture
	paste_pos = [floor(texture_size(1) / 2) - floor(seed_size(1) / 2), ...
                 floor(texture_size(2) / 2) - floor(seed_size(2) / 2)];
    texture(paste_pos(1) : paste_pos(1) + seed_size(1) - 1, paste_pos(2) : paste_pos(2) + seed_size(2) - 1, :) = ...
        sample(seed_pos(1) : seed_pos(1) + seed_size(1) - 1, seed_pos(2) : seed_pos(2) + seed_size(2) - 1, :);
    copy_map(paste_pos(1) : paste_pos(1) + seed_size(1) - 1, paste_pos(2) : paste_pos(2) + seed_size(2) - 1, :) = ...
        color_map(seed_pos(1) : seed_pos(1) + seed_size(1) - 1, seed_pos(2) : seed_pos(2) + seed_size(2) - 1, :);
    mask(paste_pos(1) : paste_pos(1) + seed_size(1) - 1, paste_pos(2) : paste_pos(2) + seed_size(2) - 1, :) = 1;
    
    % Compute layers
    layers = bwdist(mask,'chessboard');
    
    % Extend mask and texture by patch_half at every side
    mask = padarray(padarray(mask, patch_half)', patch_half)';
    if size(texture, 3) == 3
        texture = cat(3, padarray(padarray(texture(:,:,1), patch_half)', patch_half)', ...
                         padarray(padarray(texture(:,:,2), patch_half)', patch_half)', ...
                         padarray(padarray(texture(:,:,3), patch_half)', patch_half)');
    else
        texture = padarray(padarray(texture(:,:), patch_half)', patch_half)';
    end
    
    % Generate texture layer by later, from the inside out
    fprintf('Progress:   0%%');
    num_layers = max(layers(:)); 
    for l=1:num_layers
        fprintf('\b\b\b\b%3d%%',ceil(100 * l / num_layers));
        % Locate all points in the current layer
        [rows, cols] = find(layers == l);
        
        % Sort points in decreasing order of the number known neighbours
        known_neighs = zeros([patch_size, patch_size, length(rows)]);
        scores = zeros(1,length(rows));
        for i=1:length(rows)
            y = rows(i);
            x = cols(i);
            known_neighs(:, :, i) = mask(y:y+2*patch_half, x:x+2*patch_half);
            scores(i) = sum(sum(known_neighs(:, :, i)));
        end
        [~,order] = sort(scores, 'descend');
        rows = rows(order);
        cols = cols(order);
        known_neighs = known_neighs(:, :, order);
        
        % Fill every point in the current layer
        for i=1:length(rows)
        	y = rows(i);
            x = cols(i);
            patch = texture(y:y+2*patch_half, x:x+2*patch_half, :);
            patch_mask = known_neighs(:, :, i);
            
            % Select candidate patches
            distances = compute_patch_distances(patch_list, patch, patch_mask, weights);
            candidates = find(distances <= (1 + tolerance) * min(distances));
            
            % Randomly select one candidate
            candidate_id = round(rand(1) * (length(candidates) - 1)) + 1;
            sample_id = candidates(candidate_id);
            
            % Synthesize current pixel
            texture(y + patch_half, x + patch_half, :) = sample(coordinates(sample_id, 1), coordinates(sample_id, 2), :);
            copy_map(y, x, :) = color_map(coordinates(sample_id, 1), coordinates(sample_id, 2), :);
            mask(y + patch_half, x + patch_half) = 1;
        end
        
    end
    
    fprintf('\n');
    
    % Crop margins
    texture = texture(patch_half+1:texture_size(1)-patch_half, patch_half+1:texture_size(2)-patch_half, :);
end

