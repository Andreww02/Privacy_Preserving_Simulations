function [x,y] = matrixIndexToCoord(i,j,matrixSize)
    assert(1 <= i && i <= matrixSize);
    assert(1 <= j && j <= matrixSize);
    if mod(matrixSize,2) == 0
        x = -matrixSize/2 - 1/2 + j;
        y = matrixSize/2 + 1/2 - i;
    else
        x = -(matrixSize-1)/2 - 1 + j;
        y = (matrixSize-1)/2 + 1 - i;
    end
end