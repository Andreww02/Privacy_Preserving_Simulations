function [horiz,vert] = getLocalIntercepts(i,j,theta,matrixSize)
    % locates the distances from the bottom left corner 
    horiz = [];
    vert = [];
    [x,y] = matrixIndexToCoord(i,j,matrixSize);
    
    % check bottom horizontal line
    yBottom = y - 0.5;
    xBottom = yBottom/tand(theta);
    if x - 0.5 <= xBottom && xBottom <= x + 0.5
        horiz = [horiz, xBottom - x];
    else
        horiz = [horiz, NaN];
    end

    % check top horizontal line
    yTop = y + 0.5;
    xTop = yTop/tand(theta);
    if x - 0.5 <= xTop && xTop <= x + 0.5
        horiz = [horiz, xTop - x];
    else
        horiz = [horiz, NaN];
    end
    
    
    % check left vertical line
    xLeft = x - 0.5;
    yLeft= xLeft*tand(theta);
    if y - 0.5 <= yLeft && yLeft <= y + 0.5
        vert = [vert, yLeft - y];
    else
        vert = [vert, NaN];
    end
    
    
    % check right vertical line
    xRight = x + 0.5;
    yRight= xRight*tand(theta);
    if y - 0.5 <= yRight && yRight <= y + 0.5
        vert = [vert, yRight - y];
    else
        vert = [vert, NaN];
    end

end