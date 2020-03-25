I = imread('images/lena_gray_256_noisy.png');
figure(1); imshow(I);

%apply fourier transformation and shift the (0,0) coordinate to the middle
I_fft2 = fftshift(fft2(I));

%convert the complex fourier transform into the log scale
I_fft2_scaled = log(1+abs(I_fft2));
%figure(2); imshow(I_fft2_scaled,[]);

ind = 1;
for i=2:13
    I_fft2_scaled_t = I_fft2_scaled;
    I_fft2_tmp = I_fft2;
    % Detect noise region with the threshold i
    a1 = (I_fft2_scaled(65:110, 65:110) < i);
    a2 = (I_fft2_scaled(147:195, 65:110) < i);
    a3 = (I_fft2_scaled(65:110, 147:195) < i);
    a4 = (I_fft2_scaled(147:195, 147:195) < i);
    I_fft2_scaled_t(65:110, 65:110)  = I_fft2_scaled_t(65:110, 65:110).*a1;
    I_fft2_scaled_t(147:195, 65:110)  = I_fft2_scaled_t(147:195, 65:110).*a2;
    I_fft2_scaled_t(65:110, 147:195)= I_fft2_scaled_t(65:110, 147:195).*a3;
    I_fft2_scaled_t(147:195, 147:195)= I_fft2_scaled_t(147:195, 147:195).*a4;
    %subplot(3, 4, ind); imshow(I_fft2_scaled_t, []); title(sprintf("threshold=%d",i));
    
    % Get rid of the noise section from the shifted fourier transform
    I_fft2_tmp(65:110, 65:110)  = I_fft2_tmp(65:110, 65:110).*a1;
    I_fft2_tmp(147:195, 65:110)  = I_fft2_tmp(147:195, 65:110).*a2;
    I_fft2_tmp(65:110, 147:195)= I_fft2_tmp(65:110, 147:195).*a3;
    I_fft2_tmp(147:195, 147:195)= I_fft2_tmp(147:195, 147:195).*a4;
    
    % Invert fourier
    I_ifft2_tmp = abs(ifft2(I_fft2_tmp));
    
    % Show
    subplot(4, 3, ind); imshow(I_ifft2_tmp, []); title(sprintf("threshold=%d",i));
    ind = ind +1;
end
