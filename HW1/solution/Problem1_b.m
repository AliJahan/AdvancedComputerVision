% Read image
I = imread('images/house.tif');
% Image size
I = I(:,:,1);
% min and max of Samling window size and Smoothing filter width (will be multiplied by 2 in the loop)
scale_min = 1;
scale_max = 4;
% MSE matrix
mse_mat = [];
ind = 1;

% Smooth out
for smoothing_scale = 2.^(scale_min:scale_max)
    Iblur = imgaussfilt(I,smoothing_scale);
    mse_row = [];
    % Sample, reconstruct, plot, compute MSE
    for sampling_scale = 2.^(scale_min:scale_max)
        % Make a copy of smoothed out image 
        Iblur_t = Iblur;
        % Make sampling matirx
        selected = sampling_scale.*(1:(size(I,1)/sampling_scale)).';
        % Sample
        Iblur_t = Iblur_t(selected,selected);
        % Show
        %figure(s);  imshow(Iblur_t, []);
        I_reconstructed = imresize(Iblur_t,[512 512]);
        K = imabsdiff(I,I_reconstructed);
        subplot(4,4,ind); imshow(K,[]); title(sprintf("smooth=%d, sample=%d",smoothing_scale, sampling_scale));
        mse_row = [mse_row,immse(I,I_reconstructed)]; 
        ind = ind + 1;
    end
    mse_mat = [mse_mat;[mse_row]];
end