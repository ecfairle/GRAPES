function [tri] = drawLines( centers )
centers = double(centers);
tri = delaunay(centers(:,2).',centers(:,1).');
[n,~] = size(centers);
C = 50*ones(n,1);
triplot(tri,centers(:,2).',centers(:,1).');
end