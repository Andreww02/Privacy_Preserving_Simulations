function ax = displayFingerprintTranspose(imgs, extractors)
    arguments
        imgs (1,:) cell 
        extractors (1,:) cell {}
    end
    
    nRows = length(extractors) + 1;
    nCols = length(imgs);

    [x1,x2] = meshgrid(0:255, 0:255);
    x1 = x1(:);
    x2 = x2(:);
    xi = [x1 x2];

    imgCell = {};
    for col = 1:nCols
        colCell = {};
        for row = 2:nRows
            [features, ~] = extractors{row-1}(imgs{col});
            [f,xi] = ksdensity(features,xi);
            colCell{row-1} = reshape(f,[256,256]);
        end
        imgCell= horzcat(imgCell, [{imgs{col}}; {colCell{:}}']);
    end

    cmap = ["gray"; repmat("default",nRows-1,1)];
    yDirs = ["reverse"; repmat("normal",nRows-1,1)];
%     showAx = [false(1,nCols); 
%              true(nRows-2,1), false(nRows-2, nCols-1); 
%              true(1,1), true(1, nCols-1)];
    showAx = [false(1,nCols); 
             true(nRows-1,nCols)];
    ax = ATimgrid(imgCell, [nRows, nCols], 'colormaps',cmap,'yDirs',yDirs,'showAxes',showAx);

end