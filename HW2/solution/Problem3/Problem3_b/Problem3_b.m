% Read image
img = imread('../../images/house.tif');  % already grayscale
img = img(:,:,1);

% Find edges on the filtered and original image
% Gaussian filter
gaussianFilter = fspecial('gaussian',5, 1);             %radious=5, sigma=1
img_filted = imfilter(img, gaussianFilter,'symmetric');

% Canny edge detection on the filtered and original image
filted_edges = edge(img_filted, 'Canny');
img_edges = edge(img, 'Canny');

% Perform Hough Transform for lines
[H, theta, rho] = lines_accumulator(filted_edges); 

% Find Peaks
peaks = peaks_selector(H, 50); 

% Draw lines
draw_lines(img, peaks,rho,theta);
