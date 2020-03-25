function n = simi(p1,p2)
   n = sqrt(sum((repmat(p1,size(p2,1),1)-p2).^2,2));
end

