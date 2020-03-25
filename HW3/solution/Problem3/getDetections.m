function bbox = getDetections(D)

% D is a sum of difference image
% bbox is a N x 4 matrix, containing the x,y,w,h of each bbox and N is the number of bbox

% YOUR CODE HERE. DO NOT CHANGE ANYTHING ABOVE THIS.
I = imadjust(D);            %map the intensity values
bw = im2bw(I);              %convert to binary image
bw = bwareaopen(bw, 200);   %removes all connected objects that have fewer than 200 pixels
z = regionprops(bw);        %get 'Area', 'Centroid', and 'BoundingBox' of the image      
bbox = [];
if length(z) > 0
    for i=1:length(z)
       ar(i) = z(i).Area;
    end 
    th = 100;                 % We obtained this by trail and error
    feasible = find(ar > th);
    N = length(feasible);
    if N > 0
        for i=1:N
            bbox = [bbox;z(i).BoundingBox];
        end
    end
end
end