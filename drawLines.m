function [tri] = drawLines( centers )
centers = double(centers);
tri = delaunay(centers(:,2).',centers(:,1).');
end