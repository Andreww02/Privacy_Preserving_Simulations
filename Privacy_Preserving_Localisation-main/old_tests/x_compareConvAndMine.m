clear
clc


mask = getMask(3);

mask.values = ([1 0 -1;
                                  2 0 -2;
                                  1 0 -1]);

img = [   17    24     1     8    15;
    23     5     7    14    16;
     4     6    13    20    22;
    10    12    19    21     3;
    11    18    25     2     9];

convImg = conv2(img,mask.values,'same')

slideRow = true;
[~, newImg] = slideMask1D(img, mask, slideRow)



