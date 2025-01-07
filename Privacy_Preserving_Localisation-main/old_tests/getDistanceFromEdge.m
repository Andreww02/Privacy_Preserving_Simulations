function d = getDistanceFromEdge(x,y,theta)
    d = abs(x.*sind(theta) - y*cosd(theta));
end