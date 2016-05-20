function [ centers, eigs, eigsMin, directions, directionsMin ] = saveStretch( Uni,tr,numBack )
%Calculate stretch over time for each triangle

n = length(tr);

directions = zeros(n,2,100-numBack-2);
eigs = zeros(n,100-numBack-2);
eigsMin = zeros(n,100-numBack-2);
centers =  zeros(n,2,100-numBack-2);
directionsMin = zeros(n,2,100-numBack-2);


for i = numBack+2:100 
    for j = 1:n
        if numBack ~= 0
            ftest = fliplr(Uni(tr(j,:),1:2,i-numBack));
        else
            ftest = fliplr(Uni(tr(j,:),1:2,1));
        end
        mtest = fliplr(Uni(tr(j,:),1:2,i));
        Trans = fitgeotrans(ftest,mtest,'affine');
        [~, A, ~] = poldecomp(Trans.T(1:2,1:2));
        [V, D] = eig(A);
        [~, m] = max(sum(D));
        [~, mi] = min(sum(D));
        centers(j,:,i-numBack-1) = [mean(Uni(tr(j,:),2,i)) , mean(Uni(tr(j,:),1,i))];
        directions(j,:,i-numBack-1) = V(:,m)';
        directionsMin(j,:,i-numBack-1) = V(:,mi)';
        if i > numBack + 2
            directions(j,:,i-numBack-1) = directions(j,:,i-numBack-1)*sign(directions(j,1,i-numBack-2)*V(1,m));
            directionsMin(j,:,i-numBack-1) = directionsMin(j,:,i-numBack-1)*sign(directionsMin(j,1,i-numBack-2)*V(1,mi));
        end
        eigs(j,i-numBack-1) = D(m,m)-1;
        eigsMin(j,i-numBack-1) = D(mi,mi)-1;
    end
end
csvwrite('xMagnitudes(max).csv',eigs);
csvwrite('xMagnitudes(min).csv',eigsMin);
csvwrite('yDirections(min).csv',directionsMin(:,2,:));
csvwrite('xDirections(min).csv',directionsMin(:,1,:));
csvwrite('xDirections(max).csv',directions(:,1,:));
csvwrite('yDirections(max).csv',directions(:,2,:));
csvwrite('rawXPoints.csv',Uni(:,2,:));
csvwrite('rawYPoints.csv',Uni(:,1,:));
end