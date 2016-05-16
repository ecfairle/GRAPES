function [outputMatrix, select] = filterClosePoints(M)
    dist = dist2(M(:, 1:2), M(:, 1:2));
    [s, ~] = size(M);
    select = ones(s, 1);
    fileId = fopen('sqrtVals.txt', 'w');
    
    for i = 1:s
        if select(i,1) == 1
            for j = 1:s
                fprintf(fileId, 'i=%d, j=%d, sqrt=%d\n', i, j, sqrt(dist(i,j)));
                %if any two points are less than 50 pixels apart, remove
                %both
                if sqrt(dist(i,j)) < 50 && i ~= j && select(i, 1) == 1 && select(j,1) == 1
                    if M(i, 3) > M(j, 3)
                        select(j, 1) = 0;
                    else
                        select(i, 1) = 0;
                    end
                    break;
                end
            end
        end
    end
    
    fclose(fileId);
    select = logical(select);
    outputMatrix = M(select, :);
end