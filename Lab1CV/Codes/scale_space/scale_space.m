function pyr = scale_space( im , params )
% The SCALE_SPACE function calculates the scale space 
% for a given image

% first make local copies of the params struct

S      = params.S;
omin   = params.omin ;
O      = params.O;
sigma0 = params.sigma0;
sigman = params.sigman;

smin   = params.smin;
smax   = params.smax;


% If omin < 0, multiply the size of the image accordingly
%       if omin = -1 then double the image once
%       if omin = -2 then double the image twice etc...
% Do the same for omin > 0 but then halve the image instead of doubling it
if omin < 0
	for o=1:-omin
		im = double_image(im) ;
	end
elseif omin > 0
	for o=1:omin
		im = half_image(im) ;
	end
end

% store the size of the image
[M,N] = size(im);

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------
%
% The first level of the first octave has scale index (o,s) =
% (omin,smin) and scale coordinate
%
%    sigma(omin,smin) = sigma0 2^omin k^smin 
%
% The input image im is at nominal scale sigma. Thus in order to get
% the first level of the pyramid we need to apply a smoothing of
%  
%   sqrt( (sigma0 2^omin k^smin)^2 - sigman^2 ).
%
% As we have pre-scaled the image omin octaves (up or down,
% depending on the sign of omin), we need to correct this value
% by dividing by 2^omin, getting
%
%   sqrt( (sigma0 k^smin)^2 - (sigman/2^omin)^2 )
%
% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------

% Let us first compute k
% The scales are separated by a constant multiplicative factor k 
% According to Lowe , it is defined k as such:
k = 2^(1/S) ;

% Also lets define the scale index offset
s_offset = -smin+1;

%%%%%%%%%%%%%%
%First Octave%
%%%%%%%%%%%%%%

% let's store the octaves in a cell array. Each cell containing the
% images of a certain scale
pyr=cell(1,O);

% First, initialize the first octave in the pyramid
pyr{1} = zeros(M,N,smax-smin+1);

% Now smooth the first image in the scale of the first octave
% This is necessary since we have resized the image before (doubled it or
% halved depending on omin)

sig = sqrt((sigma0 * k^smin)^2  - (sigman/2^omin)^2);

pyr{1}(:,:,1)  = gaussian_filter(im, sig) ;

for s=smin+1:smax
	% Here we go from (omin,s-1) to (omin,s). The extra smoothing
	% standard deviation is
	%
	%  (sigma0 2^omin 2^(s/S) )^2 - (simga0 2^omin 2^(s/S-1/S) )^2
	%
	% After dividing by 2^omin (to take into account the fact
    % that the image has been pre-scaled omin octaves), the 
    % standard deviation of the smoothing kernel is
    %
	%   ssigma = k^s sigma0 sqrt(1-1/k^2)
  
	ssigma =   k^s * sigma0 * sqrt(1 - 1/k^2) ;
	pyr{1}(:,:,s +s_offset) = gaussian_filter(pyr{1}(:,:,s-1 +s_offset), ssigma);

end


%%%%%%%%%%%%%%%%%%%%%%%%%
%The rest of the octaves%
%%%%%%%%%%%%%%%%%%%%%%%%%

for o=2:O  
	% We need to initialize the first level of octave (o,smin) from
	% the closest possible level of the previous octave. A level (o,s)
    % in this octave corresponds to the level (o-1,s+S) in the previous
    % octave. In particular, the level (o,smin) correspnds to
    % (o-1,smin+S). However (o-1,smin+S) might not be among the levels
    % (o-1,smin), ..., (o-1,smax) that we have previously computed.
    % The closest one is
    %
	%                       /  smin+S    if smin+S <= smax
	% (o-1,sbest) , sbest = |
	%                       \  smax      if smin+S > smax
	%
	% The amount of extra smoothing we need to apply is then given by
	%
	%  ( sigma0 2^o 2^(smin/S) )^2 - ( sigma0 2^o 2^(sbest/S - 1) )^2
	%
    % As usual, we divide by 2^o to cancel out the effect of the
    % downsampling and we get
    %
	%  ( sigma 0 k^smin )^2 - ( sigma0 2^o k^(sbest - S) )^2
    %
	sbest = min(smin + S, smax) ;
	TMP = half_image(pyr{o-1}(:,:,sbest+s_offset)) ;
	
    target_sigma = sigma0 * k^smin ;
	prev_sigma = sigma0 * k^(sbest - S) ;
          
	if(target_sigma > prev_sigma)
          TMP = gaussian_filter(TMP, sqrt(target_sigma^2 - prev_sigma^2) ) ;                               
	end
	[M,N] = size(TMP) ;
	
	pyr{o}        = zeros(M,N,smax-smin+1) ;
	pyr{o}(:,:,1) = TMP ;

	for s=smin+1:smax
		% The other levels are determined as above for the first octave.		
		ssigma = k^s * sigma0 * sqrt(1 - 1/k^2) ;
		pyr{o}(:,:,s +s_offset) = gaussian_filter(pyr{o}(:,:,s-1+s_offset), ssigma);
	end
	
end

end

