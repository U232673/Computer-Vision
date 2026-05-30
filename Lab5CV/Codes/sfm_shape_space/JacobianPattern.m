%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [J]=JacobianPattern(K,n_frames,n_points,vij,priors)
% Input
% K: shape basis rank
% n_frames: number of frames 
% n_points: number of points 
% vij: visibility map
% - priors: structure with fields:
%         priors.camera_prior: boolean, 1 for rotation smoothness on, 0 off
%         priors.coeff_prior: boolean, 1 for deformation smoothness on, 0 off 
% Output
% J: the Jacobian matrix pattern
 
 
 
 
% J data term is shorter than 2xFxP if the FxP visibility contains zeros
prior_terms = priors.coeff_prior + priors.camera_prior;


% Prior_terms must be a number from 0 to 2
if prior_terms < 0 || prior_terms > 2
    error('wrong values in prior options');
end

% Jacobian matrix pattern definition
% I give you the size, but you need to define the "ones"
J = sparse(2*nnz(vij)+ prior_terms*(n_frames-1),(K+6)*n_frames + K*3*n_points);

% Column offset where the X (3D basis points) block starts in the parameter vector
X_base = (K+6)*n_frames;
% Current Jacobian row to fill (one row per visible 2D measurement)
row = 1;

% Iterate over all 2D coordinates: odd c = u (x), even c = v (y), for each frame
for c = 1:2*n_frames
    if mod(c,2)==1
        % Odd index: this coordinate is u (horizontal), belonging to frame f
        f = (c+1)/2;
        trans_index = 1;    % u depends on translation x (1st translation param)
    else
        % Even index: this coordinate is v (vertical), belonging to frame f
        f = c/2;
        trans_index = 2;    % v depends on translation y (2nd translation param)
    end

    % Column index where frame f's parameter block starts
    frame_start = (f-1)*(K+6);
    % Columns of the K shape coefficients for frame f
    L_cols = frame_start + (1:K);
    % Columns of the 4 quaternion rotation parameters for frame f
    quat_cols = frame_start + K + (1:4);
    % Column of the single relevant translation (tx for u, ty for v)
    trans_col = frame_start + K + 4 + trans_index;

    % Iterate over all points and only process visible ones
    for p = 1:n_points
        if vij(f,p)
            % Allocate column indices for the 3D coordinates of point p across all K basis shapes
            X_cols = zeros(1,3*K);
            for k = 1:K
                % Find where the 3 coordinates of point p start within basis k
                x_start = X_base + (k-1)*3*n_points + 3*(p-1);
                % Store the 3 column indices (X, Y, Z of point p in basis k)
                X_cols((k-1)*3 + (1:3)) = x_start + (1:3);
            end

            % Gather all parameter columns that influence this measurement
            cols = [L_cols, quat_cols, trans_col, X_cols];
            % Mark those columns as active (non-zero) in the current Jacobian row
            J(row, cols) = 1;
            % Advance to the next residual row
            row = row + 1;
        end
    end
end

% Priors appended in the same order as cost_RXT

% Add one prior row per consecutive frame pair if deformation smoothness is enabled
if (priors.coeff_prior == 1)
    for f = 1:(n_frames-1)
        frame_start = (f-1)*(K+6);
        next_start  =  f   *(K+6);
        % Coefficient columns of frame f
        Lf = frame_start + (1:K);
        % Coefficient columns of frame f+1
        Ln = next_start  + (1:K);
        % This prior residual depends on L of both consecutive frames
        J(row, [Lf, Ln]) = 1;
        row = row + 1;
    end
end

% Add one prior row per consecutive frame pair if rotation smoothness is enabled
if (priors.camera_prior == 1)
    for f = 1:(n_frames-1)
        frame_start = (f-1)*(K+6);
        next_start  =  f   *(K+6);
        % Quaternion columns of frame f
        Qf = frame_start + K + (1:4);
        % Quaternion columns of frame f+1
        Qn = next_start  + K + (1:4);
        % This prior residual depends on the rotation of both consecutive frames
        J(row, [Qf, Qn]) = 1;
        row = row + 1;
    end
end


% % You can see easily the Jacobian pattern using the command spy(J)
disp('Observe the Jacobian pattern...')
try
    h = figure(4);  clf(h);
    set(h, 'Name', 'Jacobian pattern', 'NumberTitle', 'off', ...
           'Visible', 'on', 'Units', 'normalized', 'Position', [0.1 0.05 0.45 0.88]);

    spy(J, 3);
    title(sprintf('Jacobian pattern  [%d x %d]  nz=%d', size(J,1), size(J,2), nnz(J)));

    % Separator between data term and prior rows
    if priors.coeff_prior || priors.camera_prior
        yline(2*nnz(vij) + 0.5, 'g--', 'Priors', 'LabelHorizontalAlignment','left');
    end
    hold off;
catch
    disp('Unable to display Jacobian pattern.');
end