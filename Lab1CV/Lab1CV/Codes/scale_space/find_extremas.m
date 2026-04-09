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
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%% MISSING CODE HERE %%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

