function im_filtered = gaussian_filter( im, sigma )
% GAUSSIAN_FILTER filters given image by convolving it
% with a Gaussian kernel with a given sigma
 
    assert(ndims(im) == 2, 'Image must be greyscale');
    
    % if needed, convert im to double
    if ~strcmp(class(im),'double')
        im = double(im);  
    end
    
    % set the size of the filter window
    sze = ceil(6*sigma);

    % ensure filter size is odd
    if ~mod(sze,2)    
        sze = sze+1;
    end
    
    % and make sure it is at least 1
    sze = max(sze,1); 
    
    h = fspecial('gaussian', [sze sze], sigma);

    im_filtered = filter2(h, im);

end

