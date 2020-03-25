display('1. All');
display('2. Image1 and Image9');
ch=input('Enter choice: ');
if ch==1
    interval1 = [1:18, 20];
    interval2 = [1:18, 20];
elseif ch==2
    interval1 = 1;
    interval2 = 9;
else
    display('Invalid Choice entered');
    return;
end

for i=interval1
    for j=interval2
        disp("---------------------------------------");
        disp("First Image:");
        disp(i);
        disp("Second Image:");
        disp(j);
        % Read images
        img1 = imread(['images/Image',num2str(i),'.tif']);
        img2 = imread(['images/Image',num2str(j),'.tif']);
        
        % Extract the corner points
        [points1, ~] = detectCheckerboardPoints(img1);
        [points2, ~] = detectCheckerboardPoints(img2);
        
        n1 = size(points1,1);
        n2 = size(points2,1);
        
        if n1==n2
            n = n1;
            A = zeros(2*n, 9);
            
            for k=1:2:n
                A(k, :) = [points1(k, 1), points1(k, 2), 1, 0, 0, 0, -points1(k, 1)*points2(k, 1), -points1(k, 2)*points2(k, 1), -points2(k, 1)];
                A(k+1, :) = [0, 0, 0, points1(k, 1), points1(k, 2), 1, -points1(k, 1)*points2(k, 2), -points1(k, 2)*points2(k, 2), -points2(k, 2)];
            end
            
            % Singular value decomposition
            [~,~,V] = svd(A);    
            H = V(:, 9);
            H = reshape(H, 3, 3)';
            
            % Show Homograhpy matrix
            disp("Homography matrix:");
            disp(H);
            
            % Checking
            P1=[points1, ones(size(points1, 1), 1)]';
            P2 = H*P1;
            P2 = P2./(P2(3, :));
            mse = immse(points2', P2(1:2, :));
            disp("MSE:");
            disp(mse);
            
        else
            disp('No 1-to-1 correspondence between the corner points')
        end
    end
end
