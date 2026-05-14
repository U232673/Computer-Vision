%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #3 
%%%              COMPUTER VISION 2025-2026
%%%              Exemplar-based methods and applications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [patch_list, coordinates] = extract_patches(image, patch_size)
%extract_patches Extracts a list of patches from a given image
%   IN:
%   image - image to extract patches from
%   patch_size - size of the patch [height width]
%   OUT:
%   patch_list - list of N patches in 4D structure:
%       (patch height, patch width, number of color channels, N)
%   coordinates - (N-by-2) matrix with coordinates of patch centers.
%
%   NOTE: patches in patch_list and in coordinates should be in the same
%         order

    [img_h, img_w, num_channels] = size(image);

    ph = patch_size(1);  % patch height
    pw = patch_size(2);  % patch width

    half_h = floor(ph / 2);
    half_w = floor(pw / 2);

    % Valid center rows and columns
    row_centers = (half_h + 1) : (img_h - half_h);
    col_centers = (half_w + 1) : (img_w - half_w);

    num_row = length(row_centers);
    num_col = length(col_centers);
    N = num_row * num_col;

    % Pre-allocate outputs
    patch_list  = zeros(ph, pw, num_channels, N);
    coordinates = zeros(N, 2);

    idx = 1;
    for r = row_centers
        for c = col_centers
            % Extract patch centered at (r, c)
            patch_list(:, :, :, idx) = image(r - half_h : r + half_h, ...
                                             c - half_w : c + half_w, :);
            coordinates(idx, :) = [r, c];
            idx = idx + 1;
        end
    end

end

