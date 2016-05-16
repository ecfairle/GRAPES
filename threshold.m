function [matrixOut] = threshold(pic, intensityThreshhold)
[x,y,z] = size(pic);
newMatrix = zeros(x,y);
for iX = 1:x
    for iY = 1:y
        %newMatrix(iX, iY) = int16(pic(iX,iY,1)) + int16(pic(iX,iY,2)) + int16(pic(iX,iY,3));
        if (int16(pic(iX,iY,1)) + int16(pic(iX,iY,2)) + int16(pic(iX,iY,3))) > intensityThreshhold
            newMatrix(iX, iY) = 1;
        else
            newMatrix(iX, iY) = 0;
        end
    end
end
matrixOut = newMatrix;
end