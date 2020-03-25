function corners = getCorners(I, ncorners)

% I is a 2D matrix 
% ncorners is the number of 'top' corners to be returned
% corners is a ncorners x 2 matrix with the 2D localtions of the corners

% FILL IN YOUR CODE HERE. DO NOT CHANGE ANYTHING ABOVE THIS.

%%
im1=im2double(I);

dx = [-1 0 1; -1 0 1; -1 0 1]; %deifne sobel mask over x
dy = dx';%deifne sobel mask over x
Ix = imfilter(im1, dx); % image gradient with sobel mask over x
Iy = imfilter(im1, dy); % image gradient with sobel mask over y
g = fspecial('gaussian',5,2); %define gaussian filter ,radius=5,sigma=2
Ix2 = imfilter(Ix.^2, g); %second derivation over x

Iy2 = imfilter(Iy.^2, g);%second derivative over y

IxIy = imfilter(Ix.*Iy, g);%second partial derivation over x & y


[r, c]=size(Ix2);% calculate the image size
E = zeros(r, c);% define a zero matrix size r*c

for i=5:1:r-4   % define the hessian matix(H) and minumum eigen values
    for j=5:1:c-4
     Ix21=sum(sum(Ix2(i-4:i+4,j-4:j+4)));
     Iy21=sum(sum(Iy2(i-4:i+4,j-4:j+4)));
     IxIy1= sum(sum(IxIy(i-4:i+4,j-4:j+4)));
     H=[Ix21 IxIy1;IxIy1 Iy21]; 
     E(i,j)=min(eig(H)); 
    end
end
thresh=graythresh(E); % get a threshold level  and omision of the smaller eigne values.
for i=1:r
    for j=1:c
        if (E(i,j)>thresh)
            E(i,j)=E(i,j);
        else
            E(i,j)=0;
        end
    end
end

se=ones(5,5);% define a structure element for morphology operation ,window 5*5 with zero center 
se(3,3)=0;
% figure
% imshow(E,[]);title('minimum eigen value');
corners=E>(imdilate(E,se));
% figure,
% imshow(corners,[]);title('corners leftover ');


[~,rt] = sort(corners(:),'descend');% sort from higher to lower
[b, a] = ind2sub([r c],rt);% turn to indices
cornersCordinates = ones(ncorners,2);
%  figure; imshow(im1, []); hold on; xlabel('Max 75 points');
for i=1:ncorners, 
% 	plot(a(i), b(i), 'r+'); 
cornersCordinates(i,2)=a(i);
cornersCordinates(i,1)=b(i);
   
end
% 
% figure
% imshow(I);hold on;plot(cornersCordinates(:,2),cornersCordinates(:,1),'*r')
clear corners
corners = cornersCordinates;
end