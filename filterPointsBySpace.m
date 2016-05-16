function [outputMatrix, outputCount] = filterPointsBySpace(mSave)
    [origSize, ~, numOfPics] = size(mSave);
    chosenPoints = ones(origSize, 1);
    count = origSize;
    
    for i= 1:origSize
        for j = 1:(numOfPics-1)
            if dist2(mSave(i,:,j),mSave(i,:,j+1)) > 3100
                chosenPoints(i, 1) = 0;
                count = count - 1;
                break;
            end
        end
    end
    
    outputMatrix = logical(chosenPoints);
    outputCount = count;
end