function peaks = peaks_selector(H, nb_peaks)
    % Find peaks in a Hough accumulator array.
    % Number of selected peaks
    numpeaks = nb_peaks;
    % Threshold at which values of H are considered to be peaks
    threshold = 0.5 * max(H(:));
    % Size of the suppression neighborhood, [M N]
    nHoodSize = floor(size(H) / 100.0) * 2 + 1;
    
    peaks = zeros(numpeaks, 2);
    num = 0;
    while(num < numpeaks)
        maxH = max(H(:));
        % Check if it is larger than threshold
        if (maxH >= threshold)
            num = num + 1;
            [r,c] = find(H == maxH);
            peaks(num,:) = [r(1),c(1)];
            rStart = max(1, r - (nHoodSize(1) - 1) / 2);
            rEnd = min(size(H,1), r + (nHoodSize(1) - 1) / 2);
            cStart = max(1, c - (nHoodSize(2) - 1) / 2);
            cEnd = min(size(H,2), c + (nHoodSize(2) - 1) / 2);
            for i = rStart : rEnd
                for j = cStart : cEnd
                        H(i,j) = 0;
                end
            end
        else
            break;          
        end
    end
    peaks = peaks(1:num, :);            
end
