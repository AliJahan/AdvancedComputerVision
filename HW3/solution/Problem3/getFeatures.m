function features = getFeatures(I, bbox)

% I is an image
% bbox is a N x 4 matrix, containing the x,y,w,h of each bbox and N is the number of bbox

I = double(I);
features = zeros(size(bbox, 1), 16);    
bbox = round(bbox);

%number of bins for HoG algorithm
nb_bin = 16;

for i = 1:size(bbox, 1)
    %HoG algorithm %
    II = I(bbox(i, 2):min(bbox(i, 2) + bbox(i, 4),size(I, 1)), bbox(i, 1):min(bbox(i, 1) + bbox(i, 3), size(I, 2)));
    II = double(II);

    Gx = II - [II(:, 2:end) II(:, end)];
    Gy = II - [II(2:end, :); II(end, :)];

    theta = angle(Gx + Gy*1i)*180 / pi; 
    theta(:, end) = []; 
    theta(end, :) = [];

    bins = -180:360 / nb_bin:180;

    H = histc(theta(:), bins); 
    H(end-1) = H(end-1) + H(end); 
    H(end) = [];

    H = H - mean(H); H = H / norm(H);
    
    features(i, :) = H';
end