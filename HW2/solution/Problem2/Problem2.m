%% Level one decomposition
I = imread('../images/house.tif'); % read the image
img = I(:,:,1);
img = im2double(img);% switch to double and normalizing
figure(1)
imshow(img,[])
title('main image')

[CA1,CH1,CV1,CD1] = dwt2(img,'db1'); % decompe the main image by haar wavelet filters

figure(2)
subplot(2,2,1)
imshow(CA1,[])
title('Approximation-L1')
subplot(2,2,2)
imshow(CH1,[])
title('Horizontal-L1')
subplot(2,2,3)
imshow(CV1,[])
title('Vertical-L1')
subplot(2,2,4)
imshow(CD1,[])
title('Diagonal-L1')

%% Level two decomposition
[CA2 CH2 CV2 CD2] = dwt2(CA1,'db1'); % level two of decomposition

D1 = [CA1 CH1;CV1 CD1];
D2 = [CA2 CH2;CV2 CD2];

figure(3)
subplot(2,2,1)
imshow(CA2,[])
title('Approximation-L2')
subplot(2,2,2)
imshow(CH2,[])
title('Horizontal-L2')
subplot(2,2,3)
imshow(CV2,[])
title('Vertical-L2')
subplot(2,2,4)
imshow(CD2,[])
title('Diagonal-L2')


figure(4)
subplot(1,3,1)
imshow(img,[]);
title('main image')

subplot(1,3,2)
imshow(D1,[]);
title('L1 dComp')

subplot(1,3,3)
imshow(D2,[]);
title('L2 dComp')

%% Reconstruction
% Reconstruct without high frequency details omision
img1 = idwt2(idwt2(CA2,CH2,CV2,CD2,'haar')...
    ,CH1,CV1,CD1,'haar');
% Reconstruction Mean Square Error & Mean Square Signal to Noise Ratio
error1 = img-img1;
MSE1 = (sum(sum(error1.*error1))/numel(img));
s1 = sum(sum(img1.^2));
MSNR1 = s1/(sum(sum(error1.*error1)));

%% Reconstruct with high frequency details omision
%% CD omision
Cd1 = zeros(size(CD1));
Cd2 = zeros(size(CD2));
img2 = idwt2(idwt2(CA2,CH2,CV2,Cd2,'haar')...
    ,CH1,CV1,Cd1,'haar');
error2 = img-img2;
MSE2 = (sum(sum(error2.*error2))/numel(img));

%% CV omision
Cv1 = zeros(size(CV1));
Cv2 = zeros(size(CV2));
img3 = idwt2(idwt2(CA2,CH2,Cv2,CD2,'haar')...
    ,CH1,Cv1,CD1,'haar');

error3 = img-img3;
MSE3 = (sum(sum(error3.*error3))/numel(img));


%% CH omision
Ch1 = zeros(size(CH1));
Ch2 = zeros(size(CH2));
img4 = idwt2(idwt2(CA2,Ch2,CV2,CD2,'haar')...
    ,Ch1,CV1,CD1,'haar');

error4 = img-img4;
MSE4 = (sum(sum(error4.*error4))/numel(img));


%% CD & CV omision
img5 = idwt2(idwt2(CA2,CH2,Cv2,Cd2,'haar')...
    ,CH1,Cv1,Cd1,'haar');

error5 = img-img5;
MSE5 = (sum(sum(error5.*error5))/numel(img));


%% CD & CH omision
img6 = idwt2(idwt2(CA2,Ch2,CV2,Cd2,'haar')...
    ,Ch1,CV1,Cd1,'haar');

error6 = img-img6;
MSE6 = (sum(sum(error6.*error6))/numel(img));


%% CV & CH omision
img7 = idwt2(idwt2(CA2,Ch2,Cv2,CD2,'haar')...
    ,Ch1,Cv1,CD1,'haar');

error7 = img-img7;
MSE7 = (sum(sum(error7.*error7))/numel(img));


%% CV & CH & CD omision
img8 = idwt2(idwt2(CA2,Ch2,Cv2,Cd2,'haar')...
    ,Ch1,Cv1,Cd1,'haar');

error8 = img-img8; % calculate mean square error
MSE8 = (sum(sum(error8.*error8))/numel(img));



figure(5)
subplot(2,4,1)
imshow(img1,[]);
title({'without omision';'MSE=1.4e-31'})

subplot(2,4,2)
imshow(img2,[]);
title({'CD omision';'MSE=2.38e-5'})

subplot(2,4,3)
imshow(img3,[]);
title({'CV omision';'MSE=4.74e-4'})

subplot(2,4,4)
imshow(img4,[]);
title({'CH omision';'MSE=5.86e-4'})

subplot(2,4,5)
imshow(img5,[]);
title({'CD & CV omision';'MSE=4.98e-4'})

subplot(2,4,6)
imshow(img6,[]);
title({'CD & CH omision';'MSE=6.1e-4'})

subplot(2,4,7)
imshow(img7,[]);
title({'CH & CV omision';'MSE=0.0011'})

subplot(2,4,8)
imshow(img8,[]);
title({'CD & CH & CV omision';'MSE=0.0011'})