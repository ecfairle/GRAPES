function [  ] = arrowPlot( centers, directions, directionsMin, eigs, eigsMin, startImage, numBack )
%Plot stretch vectors over grape image and
%save in folder 'Stretch' in current directory
%Inputs:    centers: 3xn coordiantes of centroids for each triangle
%           directions: 2xn directions of major stretch vectors 
%           directionsMin: 2xn directions of minor stretch vectors
%           eigs: 1xn magnitudes of major stretch vectors
%           eigsMin: 1xn magnitudes of minor stretch vectors
%
%   black + green => stretch + stretch
%   black + yellow => stretch + shrink
%   blue + yellow => shrink + shrink

mkdir('Stretch_Images');
imageDir = dir('DOTS');
[~,numTri] = size(eigs);
for i = 1:numTri
    A = imread(fullfile('DOTS',imageDir(2+numBack+2+startImage).name));
    h = figure('visible','off');
    imshow(A);
    hold on;
    centroid = centers(:,:,i);
    scatter(centroid(:,1),centroid(:,2),12,'g','filled');
    ind = find(eigs(:,i)>0);
    ind_ = setdiff(1:length(ind),ind);
    ind2 = find(eigsMin(:,i)>0);
    ind2_ = setdiff(1:length(ind2),ind2);
    if numel(ind)>0
        arrow3(centroid(ind,:),centroid(ind,:) + 500*repmat(tansig(eigs(ind,i)),1,2).*directions(ind,:,i));
    end
    if numel(ind_)>0
        arrow3(centroid(ind_,:),centroid(ind_,:) + 500*repmat(tansig(eigs(ind_,i)),1,2).*directions(ind_,:,i),'b');
    end
    if numel(ind2)>0
        arrow3(centroid(ind2,:),centroid(ind2,:) + 500*repmat(tansig(eigsMin(ind2,i)),1,2).*directionsMin(ind2,:,i),'g');
    end
    if numel(ind2_)>0
        arrow3(centroid(ind2_,:),centroid(ind2_,:) + 500*repmat(tansig(eigsMin(ind2_,i)),1,2).*directionsMin(ind2_,:,i),'y');
    end
    title = sprintf('Stretch_Images/Image %d', i);
    saveas(h,title,'png');
    close(h);
    hold off;
end
end

