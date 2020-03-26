clc;
boxImage = imread('D:/matlab/Video-Keyframe-Extraction-Using-RGB-Features-in-Matlab-master/keyframe/three/2283.jpg');
boxImage = rgb2gray(boxImage);
obj = VideoReader('D:/matlab/Video-Keyframe-Extraction-Using-RGB-Features-in-Matlab-master/3-3.mpg');
numFrames = obj.NumberOfFrames;
numzeros= 4;
nz = strcat('%0',num2str(numzeros),'d');
for k = 1:numFrames
    sceneImage = read(obj,k);
    %%id=sprintf(nz,k);
    %%imwrite(frame,strcat('D:/matlab/Video-Keyframe-Extraction-Using-RGB-Features-in-Matlab-master/image/',id,'.jpg'),'jpg');
    sceneImage = rgb2gray(sceneImage);
    boxPoints = detectSURFFeatures(boxImage);
    scenePoints = detectSURFFeatures(sceneImage);
   % figure(1);
%imshow(boxImage);
%title('100 Feature Points');
%hold on;
%plot(selectStrongest(boxPoints, 100));

%figure(2);
%imshow(sceneImage);
%title('100 Feature Points');
%hold on;
%plot(selectStrongest(scenePoints, 100));

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
num1=length(matchedScenePoints);
if num1>3
%%figure(3);
%%showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, matchedScenePoints, 'montage');
%%title('Putatively Matched Points(Including Outliers)');
[tform, inlierBoxPoints, inlierScenePoints] = estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
num=length(inlierScenePoints);
fprintf('第 %d 帧\n',k);
if num>50
figure(2);
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, inlierScenePoints, 'montage');
title('筛选-细匹配');
figure(1);
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, matchedScenePoints, 'montage');
title('粗匹配');
fprintf('当前帧匹配点数：%d\n',num);
end
end
%fprintf('第 %d 帧\n',k);
end
