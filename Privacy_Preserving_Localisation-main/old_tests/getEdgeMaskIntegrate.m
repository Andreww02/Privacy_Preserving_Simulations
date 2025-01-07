function mask = getEdgeMaskIntegrate(matrixSize,theta)
    % takes theta (deg) and matrix size to do fancy interp
    theta = mod(theta,360);
    mask = zeros(matrixSize);
    
    k=3;
    % function of the perpendicular distance d
    edgeFn = @(x,y) 1./(1+exp(-k*(x*sind(theta) - y*cosd(theta))));
    for i = 1:matrixSize
        for j = 1:matrixSize
            [xPt,yPt] = matrixIndexToCoord(i,j,matrixSize);
            mask(i,j) = integral2(edgeFn, xPt - 0.5, xPt + 0.5, yPt - 0.5, yPt + 0.5);
        end
    end
    mask = mask./sum(mask(:));
end