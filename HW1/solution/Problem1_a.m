% Read image
I = imread('images/house.tif');
I = I(:,:,1);
figure(1);  imshow(I);           title("Original image");

% FFT
F = fft2(I);

% Manitude
S2 = log(1+abs(F));
figure(2); imshow(S2,[]);        title("Scaled magnitude, Fourier transform of the image");

% Phase
phaseY = angle(F);
figure(3);  imshow(phaseY, []);  title("Phase, Fourier transform of the image");

% Shift to center 
shifted = fftshift(F);

% Magnitude
S21 = log(1+abs(shifted));
figure(4);  imshow(S21,[]);      title("Scaled magnitude, shifted Fourier transform of the image");
    
% Phase
phaseY1 = angle(shifted);
figure(5);  imshow(phaseY1, []); title("Phase, shifted Fourier transform of the image");

