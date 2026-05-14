%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #4 
%%%              COMPUTER VISION 2025-2026
%%%              Face Detection 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Original code from Face Detection and Alignment MTCNN

%Face detection
%The simplest way to use the face detector is the function mtcnn.detectFaces this takes in an image and returns bounding boxes, probability scores, and facial landmarks for each face detected.

% Load image and run the deep-learning face detector
im = imread("visionteam1.jpg");
[bboxes, scores, landmarks] = mtcnn.detectFaces(im);
fprintf("Found %d faces.\n", numel(scores));

% To visualise the results we can superimpose the bounding boxes and landmarks on the original image.
displayIm = insertObjectAnnotation(im, "rectangle", bboxes, scores, "LineWidth", 2);
imshow(displayIm)
hold on
for iFace = 1:numel(scores)
    scatter(landmarks(iFace, :, 1), landmarks(iFace, :, 2), 'filled');
end

% Facial landmark estimation
figure();
imshow(im);
xlim([95, 150])
ylim([115, 185])
hold on
scatter(landmarks(2, :, 1), landmarks(2, :, 2), 100, "r", "filled");
text(landmarks(2, :, 1)+3, landmarks(2, :, 2)-1, string(1:5), "FontSize", 25);