clear;
I = imread('images/gonzalezwoods725.PNG');
figure(22); imshow(I,[]);
I = rgb2gray(I);
figure(12); imshow(I,[]);
%apply fourier transformation and shift the (0,0) coordinate to the middle
I_fft2 = fft2(I);
figure(1); imshow(log(1+abs(I_fft2)), []);

I_dct2 = dct2(I);
figure(2); imshow(log(1+abs(I_dct2)), []);