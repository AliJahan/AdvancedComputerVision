function points3D = get3DPoints(points2D)

% Mean subtraction
m1 = points2D(1, :) - mean(points2D(1, :), 2);
m2 = points2D(2, :) - mean(points2D(2, :), 2);
m3 = points2D(3, :) - mean(points2D(3, :), 2);
m4 = points2D(4, :) - mean(points2D(4, :), 2);

% Stacking
M = [m1;m3;m2;m4];

% Singular values, and Right singular vectors
[~, S, V] = svd(M);
S3 = S(1:3, 1:3);

%transpose right singular vectors
V = V';
V3 = V(1:3, :);

%Matrix square root
Sq = sqrtm(S3);

points3D = Sq*V3;

end