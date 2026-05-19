%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualise(W2d,gt3D, rec3D)
% Input:
%
% W2d: Input 2D tracking data
% gt3D: 3D ground truth sequence
% rec3D: Recovered deformable 3D sequence

h=figure('Position',[1 1 500 600]);


set(gcf, 'color', [1 1 1]);
T = size(rec3D,1)/3;
min_x=min(min(W2d(1:2:end,:)));
max_x=max(max(W2d(1:2:end,:)));
min_y=min(min(W2d(2:2:end,:)));
max_y=max(max(W2d(2:2:end,:)));
max3d = max(rec3D(:));

for t=1:T
    figure(h)
    subplot(2,1,1)
    plot(W2d(2*t-1,:), W2d(2*t,:), 'g.');
    title('Input 2D point tracks')
    axis equal
    axis ([min_x max_x min_y max_y])
    subplot(2,1,2);
    hold off
    if ~isempty(gt3D)
        plot3(gt3D(3*t-2,:), gt3D(3*t-1,:), gt3D(3*t,:), 'go');
        hold on;
    end
    plot3(rec3D(3*t-2,:), rec3D(3*t-1,:), rec3D(3*t,:), 'bx');
    axis([-max3d max3d -max3d max3d -max3d max3d])
    %title('3D shape')
    %axis equal
    view(0,90)
    if ~isempty(gt3D)
        legend('3D Ground truth', '3D Reconstruction','location','NorthEastOutside');
    else
        legend('3D Reconstruction','location','NorthEastOutside');
    end
   drawnow;
   
  
   if 0,
      I = getframe;
      str = sprintf('frame%04d', t);
      imwrite(I.cdata, [str '.jpg'], 'Quality', 100);      
   end
end


end
