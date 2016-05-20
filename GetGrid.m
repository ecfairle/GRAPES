function [] = GetGrid(numBack, startImage, endPicNum, imDir, varargin)
%%
%Program Runner -> Run this to generate everything
%Inputs:    numBack: compare image n to image n - numBack, numBack = 0 means we
%compare to startImage instead of numBack images back
%           startImage: first image to plot data for
%           endPicNum: last image in sequence to consider
%           imageDir: (string) name of directory where source images are stored
%           GetGrid(...,'plot') to also also make overlayed plots
%%  

%images start at third entry in directory
dirOffset = 2;

BWthreshold = 130;
startPicNum = 1;

if(numBack > endPicNum)
    error('numBack too high');
end

if(startImage > endPicNum)
    error('start image later than end image');
end

try
    imageDir = dir(imDir);
catch
    error(imDir + ' is not a valid directory');
end
if(endPicNum > length(imageDir(not([imageDir.isdir]))))
    error('endPicNum too large');
end

%%
A = imread(fullfile(imDir,imageDir(startPicNum+dirOffset).name));
imshow(A);

%select area of image to consider
h = impoly(gca, []);
api = iptgetapi(h);
nextpos = api.getPosition();

%find points to track
B = rgb2gray(A);
T = zeros(size(B));
T(B>BWthreshold) = 1;
CC = bwconncomp(T);
[M,~] = newCenters(B,CC,1,250,BWthreshold); %higher threshold here so we don't lose points
M = double(M);

%filter points inside chosen area
ptsin = inpolygon(M(:,2), M(:,1), nextpos(:,1), nextpos(:,2));
M = M(ptsin,:);

[M, ~] = filterClosePoints(M);
M(:,1:2) = M(:,1:2)*2;
M(:,3) = M(:,3)/2;

[s1,~] = size(M);
mSave = zeros(s1,3,endPicNum - startPicNum + 1);
mSave(:, :,1) = M;

%%
%Track points by comparing relative position/size of dots in successive
%images
for i = (startPicNum+1):endPicNum
    A = imread(fullfile(imDir,imageDir(i+dirOffset).name));
    B = rgb2gray(A);
    
    %create binary image
    T = zeros(size(B));
    T(B>BWthreshold)=1;
    
    %find distinct dots in image using connected components
    CC = bwconncomp(T);
    
    %get centers/sizes of dots that are above size treshold
    %M[:,1,2] = x,y coordinates
    %M[:,3] = sizes
    
    [M_new,~] = newCentersStabilized(B,CC,1,200,BWthreshold);
    M_new = double(M_new);
    
    %scale sizes and centers for comparing to old images
    M_new(:,1:2) = M_new(:,1:2)*2;
    M_new(:,3) = M_new(:,3)/2;
    
    %find the matching dots from the last image so indices match up
    D = dist2(M,M_new);
    [~,mindex] = min(D.');
    
    M = M_new(mindex,:);
    mSave(:,:,i-startPicNum+1) = M;
end

%remove dots that are too dissimilar -> lost along the way
[scMatrix, ~] = filterPointsBySpace(mSave);
mSave = mSave(scMatrix, :, :);

%determine a good separation into trinagles (Delaunay triangularization)
tr = drawLines(mSave(:,:,1));
Dots = mSave/2;

%determine stretch for each of selected trinagles over time
[ centers, eigs, eigsMin, directions, directionsMin ] = saveStretch( Dots,tr,numBack );
if(nargin > 4)
    if(strcmp(varargin{1},'plot'))
        arrowPlot( centers, directions, directionsMin, eigs, eigsMin, startImage, numBack );
    end
end
end

