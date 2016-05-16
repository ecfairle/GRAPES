function [outputMatrix, numDotsChosen] = newCenters(G,pic, numOfDots,st,m)
j=1;
for i = 1:pic.NumObjects
    what = pic.PixelIdxList(i);
    what = what{1,1};
    [s,~] = size(what);
    if s > st
        [Y,X] = ind2sub(pic.ImageSize,what);
        A(j,2) = mean(X);
        A(j,1) = mean(Y);
        A(j,3) = s;
        j=j+1;
    end
end
numDotsChosen = j;
outputMatrix = A;
end

