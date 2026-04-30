%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #3 
%%%              COMPUTER VISION 2025-2026
%%%              Exemplar-based methods and applications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function kernel = gaussian_kernel_2d(size)
% gaussian_kernel_2d Builds 2d discrete isotropic Gaussian kernel 
%   size - size of a kernel matrix (should be odd, e.g. 3, 5, 7, etc.)

    center = ceil(size / 2);
    kernel = zeros(size, size);
    sigma2 = 2 * (size / 6.4)^2;
    normalizer = 1 / (pi * sigma2);
    
    for i = 1:size
        for j = 1:size
            distance2 = (i - center)^2 + (j - center)^2;
            kernel(i, j) = normalizer * exp(-distance2 / sigma2);
        end
    end
end

