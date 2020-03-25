function [H, theta, rho] = lines_accumulator(BW)
    % Default values for Rho and Theta
    rho_step = 1;
    theta = linspace(-90, 89, 180);
    
    max_d = sqrt((size(BW,1) - 1) ^ 2 + (size(BW,2) - 1) ^ 2);
    nb_rho = 2 * (ceil(max_d / rho_step)) + 1;
    
    d = rho_step * ceil(max_d / rho_step);
    
    nb_theta = length(theta);
    
    H = zeros(nb_rho, nb_theta);
    rho = -d : d;
    
    for i = 1 : size(BW,1)
        for j = 1 : size(BW,2)
            if (BW(i, j))
                for k = 1 : nb_theta
                    % Since theta values are in degree, we use sind & cosd
                    tmp = j * cosd(theta(k)) + i * sind(theta(k) );
                    row_ind = round((tmp + d) / rho_step) + 1;
                    H(row_ind, k) = H(row_ind, k) + 1;                   
                end
            end            
        end
    end    
end
