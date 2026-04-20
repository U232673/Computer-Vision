%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY 1
%%%              COMPUTER VISION 2025-2026
%%%              FEATURE DETECTION AND COMPARISON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clc
close all

addpath data


% Load input image
image=imread('sunflower.jpg');

if (size(image,3))
    image=rgb2gray(image);
end

% Computing point features by using different detection strategies
%
% MISSING CODE: TUNE THE ARGUMENTS FOR every XXX
% MISSING CODE: TUNE THE ARGUMENTS FOR every XXX
% For each detector below we provide a recommended tuned call wrapped in a
% try/catch so the script falls back to the default call if the option names
% are not available in the installed MATLAB/toolbox version.

% FAST: tune sensitivity via MinContrast (larger -> fewer features)
tic;
try
    features_fast = detectFASTFeatures(image, 'MinContrast', 0.08);
catch
    features_fast = detectFASTFeatures(image);
end
t_fast = toc;

% SIFT: tune ContrastThreshold, EdgeThreshold, NumOctaveLayers, Sigma
tic;
try
    features_sift = detectSIFTFeatures(image, 'ContrastThreshold', 0.008, 'EdgeThreshold', 10, 'NumOctaveLayers', 3, 'Sigma', 1.6);
catch
    features_sift = detectSIFTFeatures(image);
end
t_sift = toc;

% SURF: tune MetricThreshold (higher -> fewer detections)
tic;
try
    features_surf = detectSURFFeatures(image, 'MetricThreshold', 500);
catch
    features_surf = detectSURFFeatures(image);
end
t_surf = toc;

% KAZE: tune Threshold (smaller -> more features), NumOctaves, NumScaleLevels
tic;
try
    features_kaze = detectKAZEFeatures(image, 'Threshold', 0.0002, 'NumOctaves', 4, 'NumScaleLevels', 4);
catch
    features_kaze = detectKAZEFeatures(image);
end
t_kaze = toc;

% BRISK: tune MinContrast
tic;
try
    features_brisk = detectBRISKFeatures(image, 'MinContrast', 0.02);
catch
    features_brisk = detectBRISKFeatures(image);
end
t_brisk = toc;

% ORB: tune ScaleFactor and NumLevels (pyramid)
tic;
try
    features_orb = detectORBFeatures(image, 'ScaleFactor', 1.2, 'NumLevels', 8);
catch
    features_orb = detectORBFeatures(image);
end
t_orb = toc;

% Harris: tune MinQuality (0..1)
tic;
try
    features_harris = detectHarrisFeatures(image, 'MinQuality', 0.01);
catch
    features_harris = detectHarrisFeatures(image);
end
t_harris = toc;

% MSER: tune RegionAreaRange and ThresholdDelta to avoid tiny regions
tic;
try
    features_mser = detectMSERFeatures(image, 'RegionAreaRange', [200 8000], 'ThresholdDelta', 2);
catch
    features_mser = detectMSERFeatures(image);
end
t_mser = toc;

% Print counts for quick comparison (robustly obtain count)
function n = kpcount(feat)
    try
        n = feat.Count;
    catch
        try
            n = size(feat.Location,1);
        catch
            % MSER returns regions as cell or array; attempt length
            n = numel(feat);
        end
    end
end

fprintf('Feature counts and times (tuned calls):\n');
fprintf('FAST: %d (%.3fs)\n', kpcount(features_fast), t_fast);
fprintf('SIFT: %d (%.3fs)\n', kpcount(features_sift), t_sift);
fprintf('SURF: %d (%.3fs)\n', kpcount(features_surf), t_surf);
fprintf('KAZE: %d (%.3fs)\n', kpcount(features_kaze), t_kaze);
fprintf('BRISK: %d (%.3fs)\n', kpcount(features_brisk), t_brisk);
fprintf('ORB: %d (%.3fs)\n', kpcount(features_orb), t_orb);
fprintf('HARRIS: %d (%.3fs)\n', kpcount(features_harris), t_harris);
fprintf('MSER: %d (%.3fs)\n', kpcount(features_mser), t_mser);
%
%%


%--------------------------------------------------------------------------
% Visualize a qualitative comparison between feature detection methods
figure(1)
subplot(241)
imshow(image)
hold on
plot(features_fast.Location(:,1),features_fast.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('FAST (N=%d, %.2fs)', kpcount(features_fast), t_fast))
subplot(242)
imshow(image)
hold on
plot(features_sift.Location(:,1),features_sift.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('SIFT (N=%d, %.2fs)', kpcount(features_sift), t_sift))
subplot(243)
imshow(image)
hold on
plot(features_surf.Location(:,1),features_surf.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('SURF (N=%d, %.2fs)', kpcount(features_surf), t_surf))
subplot(244)
imshow(image)
hold on
plot(features_kaze.Location(:,1),features_kaze.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('KAZE (N=%d, %.2fs)', kpcount(features_kaze), t_kaze))
subplot(245)
imshow(image)
hold on
plot(features_brisk.Location(:,1),features_brisk.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('BRISK (N=%d, %.2fs)', kpcount(features_brisk), t_brisk))
subplot(246)
imshow(image)
hold on
plot(features_orb.Location(:,1),features_orb.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('ORB (N=%d, %.2fs)', kpcount(features_orb), t_orb))
subplot(247)
imshow(image)
hold on
plot(features_harris.Location(:,1),features_harris.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('HARRIS (N=%d, %.2fs)', kpcount(features_harris), t_harris))
subplot(248)
imshow(image)
hold on
plot(features_mser.Location(:,1),features_mser.Location(:,2),'*r','MarkerSize',4)
hold off
title(sprintf('MSER (N=%d, %.2fs)', kpcount(features_mser), t_mser))
%--------------------------------------------------------------------------

