function grad = computeGradAtCenterPixel(pixelCube)
    dx = 0.5*(pixelCube(2,3,2) - pixelCube(2,1,2));
    dy = 0.5*(pixelCube(3,2,2) - pixelCube(1,2,2));
    ds = 0.5*(pixelCube(2,2,3) - pixelCube(2,2,1));
    grad = [dx;dy;ds];
end