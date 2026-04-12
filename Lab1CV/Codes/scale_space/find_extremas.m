function keypoints = find_extremas( dog, params )
% FIND_EXTREMAS is a function that needs to take as input a computed difference of gaussian space and some parameters. 
% It should return a a binary image where each found extrema has a value of 1 and the rest has value of 0.

% define the search radius
radius = 2;

% intialize keypoints image to have the size of the original input image
keypoints = zeros(size(dog{-params.omin+1}(:,:,1)));
[m n] = size (keypoints);
for o = 1:params.O
    [M,N,S] = size(dog{o}) ;
    for s=2:S-1

        % iterate over image pixels excluding a 1-pixel border (we compare 3x3 spatial neighborhood)
        for y = 2:M-1
            for x = 2:N-1
                % value at current location and scale
                val = dog{o}(y,x,s);

                % extract 3x3x3 neighborhood (spatial 3x3, scales s-1..s+1)
                nb = dog{o}(y-1:y+1, x-1:x+1, s-1:s+1);

                % convert to vector and remove the center element for comparison
                v = nb(:);
                center_idx = 14; % linear index of center in a 3x3x3 block
                v(center_idx) = [];

                % check for strict maxima / minima and apply threshold on magnitude
                is_maxima = all(val > v) && abs(val) > params.thresh;
                is_minima = all(val < v) && abs(val) > params.thresh;

                if (is_minima || is_maxima)
                    % first transform the point to the coordinate space of the original image
                    ypt = round(y *2^(params.omin+o-1) ); 
                    xpt = round(x * 2^(params.omin+o-1) );

                    % take care of the boundaries
                    if(ypt < 1 ) 
                        ypt = 1;
                    elseif (ypt > m) 
                            ypt = m;
                    end
                    if (xpt <1 ) 
                        xpt = 1;
                    elseif (xpt > n) 
                        xpt = n;
                    end

                    % set the values of keypoints to 1
                    keypoints(ypt, xpt) = 1;
                end
            end
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Helping Instructions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Once you find a minima or a maxima, you could use this set of intructions to set the value in the keypoints image to 1

%                    if(is_minima || is_maxima)
%                        % first transform the point to the coordinate space of the original image
%                        ypt = round(y *2^(params.omin+o-1) ); 
%                        xpt = round(x * 2^(params.omin+o-1) );
%
%                        % take care of the boundaries
%                        if(ypt < 1 ) 
%                            ypt = 1;
%                        elseif (ypt > m) 
%                                ypt = m;
%                        end
%                        if (xpt <1 ) 
%                            xpt = 1;
%                        elseif (xpt > n) 
%                            xpt = n;
%                        end
%
%			             % set the values of keypoints to 1
%                        keypoints(ypt, xpt) = 1;
%		             end


end

