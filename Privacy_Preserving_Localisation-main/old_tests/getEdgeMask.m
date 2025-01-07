function mask = getEdgeMask(matrixSize,theta)
    % takes theta (deg) and matrix size to do fancy interp
%     theta = mod(theta,360);
    assert(-180 <= theta && theta <= 180);
    mask = zeros(matrixSize);
    
    for i = 1:matrixSize
        for j = 1:matrixSize
            [x,y] = matrixIndexToCoord(i,j,matrixSize);
            if getDistanceFromEdge(x,y,theta) > 1/sqrt(2)
                if  -90<= theta && theta <= 90
                    A = double(y > tand(theta)*x);
                else 
                    A = double(y < tand(theta)*x);
                end
            else
                A = matrixCoordsInterpolate(i,j,theta,matrixSize);
            end
            mask(i,j) = A;
        end
    end
    mask = mask./(matrixSize^2/2);
end