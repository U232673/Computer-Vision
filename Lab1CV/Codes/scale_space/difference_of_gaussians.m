function dog = difference_of_gaussians( pyramid, params )

% For each octave, compute the differences between consecutive scales and
% store the difference image
dog=cell(1,params.O);
for o=1:params.O
    [M,N,S] = size(pyramid{o}) ;
    dog{o} = zeros(M,N,params.S-1) ;
    for s=1:S-1
        dog{o}(:,:,s) = pyramid{o}(:,:,s+1) - pyramid{o}(:,:,s) ;
    end
end

end

