% Main function for Viola-Jones face detection

clear all
close all
clc
addpath('SubFunctions');
addpath('HaarCascades');

ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');
%Options.MergeOverlap = 0.5;
Options.Resize = false;
Objects = ObjectDetection('../data/bruce3.jpg', 'HaarCascades/haarcascade_frontalface_alt.mat', Options);
I = imread('../data/bruce3.jpg');
ShowDetectionResult(I, Objects);