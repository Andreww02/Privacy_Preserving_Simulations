function ax = displayFingerprint(imgs, extractors)
    arguments
        imgs (1,:) cell 
        extractors (1,:) cell {}
    end
    
    nRows = length(imgs);
    nCols = length(extractors) + 1;

    [x1,x2] = meshgrid(0:255, 0:255);
    x1 = x1(:);
    x2 = x2(:);
    xi = [x1 x2];

    imgCell = {};
    for row = 1:(nRows)
        rowCell = {};
        for col = 2:nCols
            [features, ~] = extractors{col-1}(imgs{row});
            [f,xi] = ksdensity(features,xi);
            rowCell{col-1} = reshape(f,[256,256]);
%             [f,xi] = ksdensity(features);
%             rowCell{col} = reshape(f,30,[]);
        end
%         tmp = [{imgs{row}}, {rowCell{:}}];
        imgCell= vertcat(imgCell, [{imgs{row}}, {rowCell{:}}]);
    end

    cmap = ["gray", repmat("default",1,nCols-1)];
    yDirs = ["reverse", repmat("normal",1,nCols-1)];
    showAx = [false,repmat(true,1,nCols-1)];
    ax = ATimgrid(imgCell, [nRows, nCols], 'colormaps',cmap,'yDirs',yDirs,'showAxes',showAx);
%     ax = ATimgrid(imgCell', [nCols, nRows], 'colormaps',cmap,'yDirs',yDirs,'showAxes',showAx);

end