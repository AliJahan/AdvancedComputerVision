clear all;

nb_mixtures = input('Enter number of mixtures:');

%Read image
[img,mp] = imread('../images/peppers_color.tif');
rgb = ind2rgb8(img(:, :, 1), mp);
figure(1); imshow(rgb); title('Original Image');

rgb = double(rgb);
[orig_row, orig_col, orig_ch] = size(rgb);

% Color Channel separation and normalization
R_ch = rgb(:, :, 1) / 255; 
G_ch = rgb(:, :, 2) / 255; 
B_ch = rgb(:, :, 3) / 255;

% Flattening each color channel
n = orig_row * orig_col;
X = zeros(n, 3);
X(:,1) = R_ch(:);
X(:,2) = G_ch(:);
X(:,3) = B_ch(:);

%% EM
s = zeros(nb_mixtures, 1);                      %standard deviation mat
w = ones(nb_mixtures, 1) / nb_mixtures;         %weight mat
p = zeros(n, nb_mixtures);                      %Membership probability mat

for chn=1:nb_mixtures
    s(chn,:) = std(X(chn:nb_mixtures:end, 1));  %init std mat
end

%Init
mu = X(randi(n, 1, nb_mixtures), :);            %initialize centroid mat
s0 = zeros(nb_mixtures, 1);             
mu0 = zeros(nb_mixtures, 3);
w0 = zeros(nb_mixtures, 1);
x_u = zeros(n, 3);
E = sum(sum(mu.^2)) + sum(sum(s.^2)) + sum(w.^2);

while E>10^-7 
    %segments membership probabilty calculation
    for mix=1:nb_mixtures
        for chn=1:3  
            x_u(:, chn) = X(:, chn)-mu(mix, chn)*ones(n, 1);
        end
        x_u = x_u.*x_u;
        p(:,mix) = power(sqrt(2 * pi) * s(mix), -3)*exp((-0.5)*sum(x_u, 2)./(s(mix).^2));
        p(:,mix) = p(:, mix)*w(mix);       
    end
    
    for mix=1:nb_mixtures
        p(:, mix) = p(:, mix)./sum(p,2);        %Normalize on x
    end
    
    Sum = sum(p,1);
    Norm = zeros(n, nb_mixtures);
    for mix=1:nb_mixtures
        Norm(:, mix) = p(:, mix) / Sum(mix);    %Normalize on y
    end
    
    %Snapshot of vars to keep them safe from changing for the next round
    mu0 = mu;
    s0 = s;
    w0 = w;
    
    mu=(Norm.') * X;
    for mix=1:nb_mixtures
        for chn=1:3
            x_u(:, chn) = X(:, chn) - mu(mix, chn) * ones(n, 1);
        end
        x_u=x_u.^2;
        x_us=sum(x_u, 2);
        s(mix)=sqrt(1 / 3 * (Norm(:, mix).') * x_us);
    end
    
    w = (sum(p)/n).';
    E = sum(sum((mu - mu0).^2)) + sum(sum((s - s0).^2)) + sum((w - w0).^2);
end

%% Using EM result to draw segments and combination of segments
img = p * mu(:, 1:3);
comball = zeros(orig_row, orig_col, orig_ch);

for chn=1:orig_ch
    comball(:,:,chn) = reshape(img(:,chn), [orig_row, orig_col]);
end

%Unnormalize: [0-1] => [0-255]
comball = uint8(comball * 255);

figure(2); imshow(comball); title('Combined segments');

[Y,I] = max(p,[],2);
for i=1:nb_mixtures
    temp1 = zeros(size(p));
    temp1(find(I == i), :) = p(find(I == i), :);
    img = temp1 * mu(:, 1:3);
    mask = zeros(orig_row, orig_col, orig_ch);
    for chn=1:3
        mask(:, :, chn) = reshape(img(:, chn), [orig_row, orig_col]);
    end
    mask = uint8(mask * 255);
    figure(i+2); imshow(mask); title(sprintf("Segment%d", i));
end