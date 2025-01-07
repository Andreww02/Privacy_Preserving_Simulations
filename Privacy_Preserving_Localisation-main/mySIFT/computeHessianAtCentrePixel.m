function hess = computeHessianAtCentrePixel(cube)
    centreVal = cube(2,2,2);

    dxx = cube(2,3,2) - 2*centreVal + cube(2,1,2);
    dyy = cube(3,2,2) - 2*centreVal + cube(1,2,2);
    dss = cube(2,2,3) - 2*centreVal + cube(2,2,1);

    dxy = 0.25*(cube(3,3,2) - cube(3,1,2) - cube(1,3,2) + cube(1,1,2));
    dxs = 0.25*(cube(2,3,3) - cube(2,3,1) - cube(2,1,3) + cube(2,1,1));
    dys = 0.25*(cube(3,2,3) - cube(3,2,1) - cube(1,2,3) + cube(1,2,1));

    hess = [dxx dxy dxs;
                 dxy dyy dys;
                 dxs dys dss];
end