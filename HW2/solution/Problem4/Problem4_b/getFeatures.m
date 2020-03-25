function feat = getFeatures(I, corners)

% I is an image
% corners is a N x 2 matrix with N 2D corner point coordinates
% feat is a N x n_feat matrix where n_feat is the feature dimension of a point

% FILL IN YOUR CODE HERE. DO NOT CHANGE ANYTHING ABOVE THIS.
%%
Ix=I;
Iy=I;

r=size(I,1);
c=size(I,2);
% get the gradient over x,then y
for i=1:r-2               
    Iy(i,:)=(I(i,:)-I(i+2,:));
end
for i=1:c-2
    Ix(:,i)=(I(:,i)-I(:,i+2));
end
Ix=double(Ix);
Iy=double(Iy);
angle=atand(Ix./Iy); % Matrix containing the angles of each edge gradient
angle=imadd(angle,90); %Angles in range (0,180)
magnitude=sqrt(Ix.^2 + Iy.^2);
angle(isnan(angle))=0;
magnitude(isnan(magnitude))=0;
feature=[]; %initialized the feature vector
% Iterations for Blocks
for i = 1: size(corners,1)
    
    mag_patch = magnitude(corners(i,1)-4 : corners(i,1)+3 ...
        , corners(i,2)-4 : corners(i,2)+3);
    
    ang_patch = angle(corners(i,1)-4 : corners(i,1)+3 ...
        , corners(i,2)-4 : corners(i,2)+3);
    
    block_feature=[];
    
    %Iterations for cells in a block
    for x= 0:1
        for y= 0:1
            angleA =ang_patch(4*x+1:4*x+4, 4*y+1:4*y+4);
            magA   =mag_patch(4*x+1:4*x+4, 4*y+1:4*y+4);
            histr  =zeros(1,16);
            
            %Iterations for pixels in one cell
            for p=1:4
                for q=1:4
                    %
                    alpha= angleA(p,q);
                    
                    % Binning Process (Bi-Linear Interpolation)
                    if alpha>5.625  && alpha<=16.875
                        histr(1)=histr(1)+ magA(p,q)*(16.875-alpha)/11.25;
                        histr(2)=histr(2)+ magA(p,q)*(alpha-5.625)/11.25;
                    elseif alpha>16.875 && alpha<=28.125
                        histr(2)=histr(2)+ magA(p,q)*(28.125-alpha)/11.25;
                        histr(3)=histr(3)+ magA(p,q)*(alpha-16.875)/11.25;
                    elseif alpha>28.125 && alpha<=39.375
                        histr(3)=histr(3)+ magA(p,q)*(39.375-alpha)/11.25;
                        histr(4)=histr(4)+ magA(p,q)*(alpha-28.125)/11.25;
                    elseif alpha>39.375 && alpha<=50.625
                        histr(4)=histr(4)+ magA(p,q)*(50.625-alpha)/11.25;
                        histr(5)=histr(5)+ magA(p,q)*(alpha-39.375)/11.25;
                    elseif alpha>50.625 && alpha<=61.875
                        histr(5)=histr(5)+ magA(p,q)*(61.875-alpha)/11.25;
                        histr(6)=histr(6)+ magA(p,q)*(alpha-50.625)/11.25;
                    elseif alpha>61.875 && alpha<=73.125
                        histr(6)=histr(6)+ magA(p,q)*(73.125-alpha)/11.125;
                        histr(7)=histr(7)+ magA(p,q)*(alpha-61.875)/11.125;
                    elseif alpha>73.125 && alpha<=84.375
                        histr(7)=histr(7)+ magA(p,q)*(84.375-alpha)/11.125;
                        histr(8)=histr(8)+ magA(p,q)*(alpha-73.125)/11.125;
                    elseif alpha>84.375 && alpha<=95.625
                        histr(8)=histr(8)+ magA(p,q)*(95.625-alpha)/11.125;
                        histr(9)=histr(9)+ magA(p,q)*(alpha-84.375)/11.125;
                    elseif alpha>95.625 && alpha<=106.875
                        histr(9)=histr(9)+ magA(p,q)*(106.875-alpha)/11.125;
                        histr(10)=histr(10)+ magA(p,q)*(alpha-95.625)/11.125;
                        elseif alpha>106.875 && alpha<=118.125
                        histr(10)=histr(10)+ magA(p,q)*(118.125-alpha)/11.25;
                        histr(11)=histr(11)+ magA(p,q)*(alpha-106.875)/11.25;
                        elseif alpha>118.125 && alpha<=129.375
                        histr(11)=histr(11)+ magA(p,q)*(129.375-alpha)/11.25;
                        histr(12)=histr(12)+ magA(p,q)*(alpha-118.125)/11.25;
                        elseif alpha>129.375 && alpha<=140.625
                        histr(12)=histr(12)+ magA(p,q)*(140.625-alpha)/11.25;
                        histr(13)=histr(13)+ magA(p,q)*(alpha-129.375)/11.25;
                        elseif alpha>140.625 && alpha<=151.875
                        histr(13)=histr(13)+ magA(p,q)*(151.875-alpha)/11.25;
                        histr(14)=histr(14)+ magA(p,q)*(alpha-140.625)/11.25;
                        elseif alpha>151.875 && alpha<=163.125
                        histr(14)=histr(14)+ magA(p,q)*(163.125-alpha)/11.25;
                        histr(15)=histr(15)+ magA(p,q)*(alpha-151.875)/11.25;
                        elseif alpha>163.125 && alpha<=174.375
                        histr(15)=histr(15)+ magA(p,q)*(174.375-alpha)/11.25;
                        histr(16)=histr(16)+ magA(p,q)*(alpha-163.125)/11.25;
                    elseif alpha>=0 && alpha<=5.625
                        histr(1)=histr(1)+ magA(p,q)*(alpha+10)/20;
                        histr(16)=histr(16)+ magA(p,q)*(10-alpha)/20;
                    elseif alpha>174.375 && alpha<=180
                        histr(16)=histr(16)+ magA(p,q)*(190-alpha)/20;
                        histr(1)=histr(1)+ magA(p,q)*(alpha-170)/20;
                    end
                    
                    
                end
            end
            block_feature=[block_feature histr]; % Concatenation of Four histograms to form one block feature
            
        end
    end
    
    % Normalize the values in the block using L1-Norm
    block_feature=block_feature/sqrt(norm(block_feature)^2+.01);
    
    feature(i,:)=block_feature; %Features concatenation
end


feature(isnan(feature))=0; %Removing Infinitiy values
% Normalization of the feature vector using L2-Norm
feature=feature/sqrt(norm(feature)^2+.001);
for z=1:length(feature)
    if feature(z)>0.2
        feature(z)=0.2;
    end
end
feat=feature/sqrt(norm(feature)^2+.001);
% figure,imshow(feature,[]),title('extracted feature from HOG');
end