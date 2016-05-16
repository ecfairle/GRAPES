function [outputMatrix, numDotsChosen] = newCentersStabilized(G,pic, numOfDots,st,m)
j=1;
for i = 1:pic.NumObjects
    what = pic.PixelIdxList(i);
    what = what{1,1};
    [s,~] = size(what);
    if s > st
        [Y,X] = ind2sub(pic.ImageSize,what);
        F = double(G(what));
        F = (F-m)/(255-m);
        Y  = Y.*F/sum(F);
        X  = X.*F/sum(F);
        A(j,2) = sum(X);
        A(j,1) = sum(Y);
        A(j,3) = s;
        j=j+1;
    end
end
numDotsChosen = j;
outputMatrix = A;
end
