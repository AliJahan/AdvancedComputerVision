function [TPR,FPR] = getROC(pred,gt)

% gt is the ground truth vector of 1 or 0 of size n_samples x 1. 1
% indicates a positive and 0 negative
% pred is a vector of predictions of size n_samples x 1
% TPR is the True Positive Rate
% FPR is the False Positive Rate

% FILL IN

TPR = [];
FPR = [];
thresh = linspace(min(pred), max(pred), 30)
for th=thresh
    for j=1:length(pred)
        if pred(j)>th
          lbl(j) = 1;
        else
          lbl(j) = 0;
        end
    end
    tp = 0; fp = 0;p = sum(gt);
    n = length(gt) - p;
    for i=1:length(gt)
        if gt(i)==1 && lbl(i)==1
            tp = tp + 1;
        elseif gt(i)==0 && lbl(i)==1
            fp = fp + 1;
        end
    end
    TPR = [TPR, tp/p];
    FPR = [FPR, fp/n];
end


    
