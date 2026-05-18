% Main function for Viola-Jones face detection

clear all
close all
clc
addpath('SubFunctions');
addpath('HaarCascades');

ConvertHaarcasadeXMLOpenCV('HaarCascades/haarcascade_frontalface_alt.xml');
Options.MergeOverlap = 0.2;
Options.Resize = false;
Objects = ObjectDetection('../data/faces.png', 'HaarCascades/haarcascade_frontalface_alt.mat', Options);
I = imread('../data/faces.png');
ShowDetectionResult(I, Objects);