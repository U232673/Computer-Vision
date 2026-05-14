%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #3 
%%%              COMPUTER VISION 2025-2026
%%%              Exemplar-based methods and applications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function distances = compute_patch_distances(patch_list, patch, mask, weights)
%compute_patch_distances Computes distances between the given patch and 
%                        all patches in the list of patches
%   IN:
%	patch_list - list of N patches in 4D structure:
%       (patch height, patch width, number of color channels, N)
%   patch - given patch
%   mask - binary mask to be applied in distance computation
%   weights - intra-patch weights
%   OUT:
%   distances - array of size N, containing all patch distances

    [~, ~, num_channels, ~] = size(patch_list);

    % Combine mask and weights into a single 2D weight map.
    % Unknown pixels (mask == 0) contribute nothing to the distance.
    combined_weights = weights .* mask;  % (ph x pw)

    % Normalisation factor: sum of weights over known pixels only.
    % This makes distances comparable regardless of how many pixels are known.
    norm_factor = sum(combined_weights(:));  % scalar

    % Expand combined_weights to match the number of channels so we can
    % operate on the full colour patch at once.
    % Result shape: (ph x pw x channels)
    w_expanded = repmat(combined_weights, [1, 1, num_channels]);

    % Broadcast the query patch against the whole patch_list
    % patch : (ph x pw x channels x  1)
    % patch_list : (ph x pw x channels x  N)
    % diff : (ph x pw x channels x  N)
    diff = double(patch_list) - double(patch);

    % Weighted squared differences, summed over height, width and channels
    % w_expanded has no 4th dimension, so it broadcasts across N patches
    weighted_sq = (diff .^ 2) .* w_expanded;    % (ph x pw x channels x N)

    % Sum over the first three dimensions (spatial + colour), keep N
    distances = squeeze(sum(weighted_sq, [1, 2, 3]));

    % Normalise so that a patch with fewer known neighbours is comparable
    % to one whose neighbourhood is fully known
    if norm_factor > 0
        distances = distances / norm_factor;
    end    

end

