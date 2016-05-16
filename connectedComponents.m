function [ labelIm,curlabel ] = connectedComponents( bin )
    [r,c] = size(bin);
    pix = bin(:);
    curlabel = 1;
    labelIm = zeros(r,c);
    q = 2;
    queue = zeros(1,1);
    for i = c+1:c*(r-1)
        if mod(i,c) == 0 || mod(i,c) == 1
            continue;
        end
        if pix(i) == 1
            [y,x] = ind2sub([r,c],i);
            if labelIm(y,x) == 0
                labelIm(y,x) = curlabel;
                queue = [queue,i];
                [m,n] = size(queue);
                while q <= n
                    ind = queue(q);
                    [y,x] = ind2sub([r,c],ind);
                    for j = y-1:y+1
                        for k = x-1:x+1
                            if j == r + 1 || k == c + 1 || j == 0 || k == 0
                            else if labelIm(j,k) == 0
                                    if bin(j,k) == 1
                                        queue = [queue,sub2ind([r,c],j,k)];
                                        labelIm(j,k) = curlabel;
                                    end
                                 end
                            end
                        end
                    end
                    q = q + 1;
                    [m,n] = size(queue);
                end
                curlabel = curlabel + 1;
            end
        end
    end
end

