function [ Uni,UniStab,tr ] = GetGrid( )

%MACROS
dirOffset = 2;

BWthreshold = 130;
startPicNum = 1;
endPicNum = 100;
dirName = 'DOTS';

imageDir = dir(dirName);
A = imread(fullfile(dirName,imageDir(startPicNum+dirOffset).name));
imshow(A);

%select area of image to consider
h = impoly(gca, []);
api = iptgetapi(h);
nextpos = api.getPosition();

%determine 
B = rgb2gray(A);
T = zeros(size(B));
T(B>BWthreshold) = 1;
CC = bwconncomp(T);
[M,~] = newCenters(B,CC,1,250,BWthreshold);
M = double(M);
ptsin = inpolygon(M(:,2), M(:,1), nextpos(:,1), nextpos(:,2));

M = M(ptsin,:);
[M, ~] = filterClosePoints(M);
M(:,1:2) = M(:,1:2)*2;
M(:,3) = M(:,3)/2;
firstM = M;

[s1,~] = size(M);
mSave = zeros(s1,3,endPicNum - startPicNum + 1);
mSave2 = zeros(s1,3,endPicNum - startPicNum + 1);
mSave(:, :,1) = firstM;
mSave2(:, :,1) = firstM;
for i = (startPicNum+1):endPicNum
    A = imread(fullfile(dirName,imageDir(i+dirOffset).name));
    B = rgb2gray(A);
    T = zeros(size(B));
    T(B>BWthreshold)=1;
    CC = bwconncomp(T);
    [M1,~] = newCenters(B,CC,1,200,BWthreshold);
    [M2,~] = newCentersStabilized(B,CC,1,200,BWthreshold);
    M1 = double(M1);
    M2 = double(M2);
    M1(:,1:2) = M1(:,1:2)*2;
    M1(:,3) = M1(:,3)/2;
    D = dist2(M,M1);
    [~,mindex] = min(D.');
    M = M1(mindex,:);
    M2 = M2(mindex,:);
    mSave(:,:,i-startPicNum+1) = M;
    mSave2(:,:,i-startPicNum+1) = M2;
end

[scMatrix, ~] = filterPointsBySpace(mSave);
mSave = mSave(scMatrix, :, :);
mSave2 = mSave2(scMatrix, :, :);
tr = drawLines(mSave(:,:,1));
Uni = mSave/2;
UniStab = mSave2/2;
end

