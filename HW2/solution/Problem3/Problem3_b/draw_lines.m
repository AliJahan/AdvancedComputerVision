function draw_lines(img, peaks, rho, theta)
    figure();
    imshow(img);
    hold on;
    for i = 1 : size(peaks,1)
       rho_i = rho(peaks(i,1));
       theta_i = theta(peaks(i,2));
       if theta_i == 0
           x1 = rho_i;
           x2 = rho_i;
           if rho_i > 0
               y1 = 1;
               y2 = size(img,1);
               plot([x1,x2],[y1,y2],'r'); 
           end           
       else
           x1 = 1;
           x2 = size(img, 2);
           y1 = (rho_i - x1 * cosd(theta_i)) / sind(theta_i);
           y2 = (rho_i - x2 * cosd(theta_i)) / sind(theta_i);
           plot([x1,x2],[y1,y2],'r'); 
       end
             
    end
end
