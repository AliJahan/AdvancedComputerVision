clear all;
addpath(genpath('vlfeat'));

% Number of random samples of 8-points subsets
number_of_random_8points_sets = 100000;
number_of_random_8points_sets = input('Enter number of samples: ');

% Read images
Img1 = imread('viprectification_deskLeft.png');
Img2 = imread('viprectification_deskRight.png');

% Get SIFT features
[img1Frames, img1Desc] = getSIFTFeatures(Img1);
[img2Frames, img2Desc] = getSIFTFeatures(Img2);

% Get matches
matches = matchFeatures(img1Desc', img2Desc');
disp("Number of found matches:");
disp(size(matches,1));

% Show matches
img1SIFTCoords = img1Frames(1:2, matches(:, 1))';
img2SIFTCoords = img2Frames(1:2, matches(:, 2))';
figure,showMatchedFeatures(Img1, Img2, img1SIFTCoords, img2SIFTCoords, 'montage'), title('SIFT matchings')


for i=1:number_of_random_8points_sets
    % Shuffling
    points = size(matches, 1);
    p = randperm(points);
    chosen = ones(8, 1);
    
    % Chosens 8-points subset
    chosenSet1 = [img1SIFTCoords(p(1:8), :), chosen]';
    chosenSet2 = [img2SIFTCoords(p(1:8), :), chosen]';
    
    %% Calculating F for the chosen 8-points set
    c = mean(chosenSet1, 2);
    d = sqrt(sum((chosenSet1 - repmat(c, 1, size(chosenSet1, 2))).^2, 1));
    md = mean(d);
    T1 = [sqrt(2)/md, 0, -sqrt(2)/md*c(1); 0, sqrt(2)/md, -sqrt(2)/md*c(2); 0, 0, 1];
    
    c = mean(chosenSet2, 2);
    d = sqrt(sum((chosenSet2 - repmat(c, 1, size(chosenSet2, 2))).^2, 1));
    md = mean(d);
    T2 = [sqrt(2)/md, 0, -sqrt(2)/md*c(1); 0, sqrt(2)/md, -sqrt(2)/md*c(2); 0, 0, 1];
    
    ch1n = T1 * chosenSet1;
    ch2n = T2 * chosenSet2;
    W = [ repmat(ch2n(1, :)', 1, 3) .* ch1n', repmat(ch2n(2, :)', 1, 3) .* ch1n', ch1n(1:3, :)'];
    % Get singular value decomposition
    [~, ~, V] = svd(W);
    F_norm = reshape(V(:, end), 3, 3)';
    % Get singular value decomposition
    [U, S, V] = svd(F_norm);
    F_norm_prime = U*diag([S(1) S(5) 0])*(V');
    F = T2' * F_norm_prime * T1;
    
    %% Calculating error on the rest of matched points
    % The rest of points which is all matches points - the chosen 8-points set
    unchosenSet1 = [img1SIFTCoords(p(9:points), :), ones(points-8, 1)]';
    unchosenSet2 = [img2SIFTCoords(p(9:points), :), ones(points-8, 1)]';
    
    % Calculating sampson distance between the chosen points and unchosen points
    for j=1:points-8
        pnt1 = unchosenSet1(:, j);
        pnt2 = unchosenSet2(:, j);
        samp_dist(j) = getSampsonDist(pnt1, pnt2, F);
    end
    
    % Save Fundamental matrix
    F_tot(i, :, :) = F;
    
    % Save the mean of sampson dist of the current chosen set
    sampson_dist_mean_mat(i) = mean(samp_dist);

end

% Minimum sampson dist
format compact;
[~, idx] = min(sampson_dist_mean_mat);
minimum_F = reshape(F_tot(idx, :, :), 3, 3);
disp('Fundamental Matrix of the least Error + its error:')
disp(minimum_F)
disp(sampson_dist_mean_mat(idx))