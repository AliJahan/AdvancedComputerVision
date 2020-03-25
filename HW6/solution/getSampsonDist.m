function sampson_dist = getSampsonDist(p1, p2, F)
    sampson_dist = (p1'*F*p2)^2/((norm(F'*p1))^2+(norm(F'*p2))^2);
end