clear all; close all; clc;

% DO NOT MODIFY ANYTHING IF NOT MENTIONED

load subset
load ucf101dataset
subset = cellstr(subset);
idx = strcmp(subset,'training'); trfeature = double(feature(idx,:)); trlabel = double(label(idx)'); 
idx = strcmp(subset,'testing'); tefeature = double(feature(idx,:)); telabel = double(label(idx)');

batchsize = 1024; % FILL IN AND MODIFY TO SEE CHANGE IN PERFORMANCE
lr = 0.01;        % FILL IN AND MODIFY TO SEE CHANGE IN PERFORMANCE
classlist = unique(trlabel);
trlabel1hot = double(repmat(trlabel,[1 length(classlist)]) == repmat(classlist',[length(trlabel) 1]));
telabel1hot = double(repmat(telabel,[1 length(classlist)]) == repmat(classlist',[length(telabel) 1]));


theta = randn(size(trfeature, 2), size(trlabel1hot, 2)); % INITIALIZE; FILL IN
diff = 1;
epoch = 1;

while diff > 1e-10 && epoch < 200
    theta_old = theta;
    
    % Train
    for i = 1:batchsize:size(trlabel1hot,1)
        endpos = min(size(trlabel1hot,1),i+batchsize-1);
        theta = apply_gradients(trfeature(i:endpos,:),trlabel1hot(i:endpos,:),theta,lr);
    end
    
    diff = norm(theta_old-theta);
    
    % Predict; FILL IN TO ASSIGN test accuracy to variable test_accuracy
    pred = 1./(1 + exp(-tefeature*theta));
    [~, idx] = max(pred, [], 2);
    count=0;
    for j =1:length(telabel)     
        if telabel(j)==(idx(j)-1)
            count=count+1;
        end
    end
    test_accuracy=count*100.0/length(telabel);
    % Plot
     drawnow,plot(epoch,test_accuracy,'*b'); hold on;
     xlabel('Epoch Number'); ylabel('Test Accuracy'); xlim([1 max(20,epoch)])
    epoch = epoch + 1;
    
    % Update Learning Rate; FILL IN IF REQUIRED
%      if mod(epoch,50)==0&& epoch>50
%          lr=lr*2; 
%      end
end
fprintf('Test Accuracy: %f\n', test_accuracy);

% FILL IN THE FIRST ARGUMENT; SHOULD BE A COLUMN VECTOR CONTAINING THE 50th
% CATEGORY PREDICTION
[TPR, FPR] = getROC(pred(:, 50), telabel1hot(:, 50));
figure,plot(FPR,TPR,'LineWidth',1.5);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
grid on