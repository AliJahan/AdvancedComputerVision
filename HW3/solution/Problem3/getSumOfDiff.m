function sum_of_diff = getSumOfDiff(I)

% I is a 3D tensor of image sequence where the 3rd dimention represents the time axis

% YOUR CODE HERE. DO NOT CHANGE ANYTHING ABOVE THIS.
Dim = 3;
total = nchoosek(Dim,2);
t = size(I,3);
sum_of_diff = uint8(zeros(size(I, 1), size(I, 2), size(I, 3) - Dim + 1));

for k=1:t-Dim+1
    for i=1:Dim-1
        for j=i+1:Dim
            sum_of_diff(:, :, k) = sum_of_diff(:, :, k) + abs((I(:, :, k + i - 1)) - (I(:, :, k + j - 1))) / total;
        end
    end
end
end        