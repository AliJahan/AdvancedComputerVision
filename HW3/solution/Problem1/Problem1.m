clear all;

% Read image
display('***** Choose image *****');
display('1. House');
display('2. Peppers');
ch=input('Enter choice of image: ');
if ch==1
    I = imread('../images/house.tif');
    I = I(:, :, 1);
    figure; imshow(I); title('Original Image');
elseif ch==2
    [im, mp] = imread('../images/peppers_color.tif');
    RGB = ind2rgb8(im(:,:,1), mp);
    I=rgb2gray(RGB);
    figure; imshow(RGB); title('Original Image');
    figure; imshow(I); title('Gray Image');
else
    display('Invalid Choice entered');
    return;
end

[orig_row, orig_col]=size(I);

%Resize => down 
scale_factor = 4;                               %has to be power of 2 numbers!						
new_row=orig_row/scale_factor;					
new_col=orig_col/scale_factor;					
I= imresize(I, [new_row, new_col]);				%resize

%Normalized cuts
seg=norm_cut(I);	

%Resize => up	
seg=imresize(seg, [orig_row, orig_col]);

%Show
figure; imshow(uint8(seg)); title('Segmented Image');