function matches = getMatches(featI,featR)

% featI and featR are two feature matrices of dim N1 x n_feat and N2 x n_feat respectively.
% matches is a N x 2 matrix indicating the indices of matches. N <= % min(N1,N2).
% For e.g. if featI(i,:) matches with featR(j,:), then matches should have [i,j] as one of its row.

% FILL IN YOUR CODE HERE. DO NOT CHANGE ANYTHING ABOVE THIS.
counter = 0;
supra =[]; %initialize the spura
meanDistances = 0;
for i=1:size(featI,1)
    for j=1:size(featR,1)
        
%         distance measure
% get the distance of sum square
        distanceValue=sum(xcorr2(featI(i,:),featR(j,:)).^2,2);
        % threshold to get higher values
        if distanceValue >0.006
            counter = counter + 1;
            matches(counter,:)=[i,j];
            
        end
        
        supra = [ supra distanceValue];
    end
    
    
end

meanDistances = mean(supra,2);

end
