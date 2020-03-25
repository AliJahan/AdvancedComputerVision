function out = norm_cut(I)
%% Step 1: Constructing weighted graph
flatten = reshape(I(:, :), [], 1);                              %flatten image mat
sigma = std(double(flatten));                                   %standard dev
W = exp(-1 * squareform(pdist(flatten, @simi) ) / sigma ^ 2);    %construct weighted graph based on similarity
D = diag(sum(W));                                               %diagonal mat with total connections from each node to all other nodes 
%% Step 2: Obtaining smallest eigenvalues 
lamb = D - W;		
[ev, ~] = eig(lamb, D);

%% Step 3: using smallest eigen values to partition
S = ev(:,2);                                                    %selecting the second smallest eigen value 
%Partitioning
S(S>0) = 1; S(S<0) = 0;                                         %partitioning coefficients 
out = double(flatten).*S;                                       %partitioning 
[r, c] = size(I);
out = reshape(out, r, c);                                       %reshape to orignal image
end