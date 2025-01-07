function newImg = getSobelEdgeMag(img)
    
    mask.values = ([1 0 -1;
                                      2 0 -2;
                                      1 0 -1]);
    horiz = conv2(img, mask.values, 'same');


    mask.values = ([1 2 1;
                                      0 0 0;
                                      -1 -2 -1]);
    vert = conv2(img, mask.values, 'same');
    newImg = sqrt(vert.^2 + horiz.^2);

end