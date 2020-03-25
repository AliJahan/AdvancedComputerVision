% Read image
display('***** Choose image *****');
display('1. House');
display('2. Lena');
ch=input('Enter choice of transform: ');
if ch==1
    I = imread('../../images/house.tif');
elseif ch==2
    I = imread('../../images/lena_gray_256.tif');
else
    display('Invalid Choice entered');
    return;
end

I = I(:,:,1);

% Laplacian of the gaussian
ind = 1;
figure(1);
for alpha=.001:.25:1.001
    for window=3:4:15
        h = fspecial('log', [window,window], alpha);
        blurred = imfilter(I, h, 'symmetric', 'conv'); 
        subplot(5,4,ind); imshow(blurred,[]); title(sprintf('W=%d, S=%.3f',window,alpha));
        ind = ind + 1;
    end
end

% Canny filter
figure(2);
ind = 1;
for i=0.01:0.05:1
    canny = edge(I,'Canny', [0 i]);
    subplot(5, 4, ind); imshow(canny, []); title(sprintf('Threshold=%.2f',i)); %imshow(cny, []);
    ind = ind + 1;
end 

figure(3); imshow(edge(I,  'Canny'), []);