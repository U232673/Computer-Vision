%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #3 
%%%              COMPUTER VISION 2025-2026
%%%              Exemplar-based methods and applications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function color_map = build_color_map(size)
%build_color_map Builds a color map where each pixel has its own color
%   size - desired size of a color map: [height width]

    color_map = zeros(size(1), size(2), 3);
    for i=1:size(1)
        for j=1:size(2)
            color_map(i, j, 1) = j * 255 / size(2);
            color_map(i, j, 2) = i * j * 255 / (size(1) * size(2));
            color_map(i, j, 3) = i * 255 / size(1);
        end
    end
    
    color_map = uint8(color_map);
end

