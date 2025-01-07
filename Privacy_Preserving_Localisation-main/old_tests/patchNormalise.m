function newImg = patchNormalise(img, R_window)
    % subtracting the mean value of the surrounding pixel intensities then dividing by 
    % the standard deviation of the surrounding pixel intensities
    
    % for each pixel in noremal image, construct a square around it with
    % side length R_window, then filter down to a circle by considering
    % euclidean distance

    assert(R_window>=1);
    
    newImg = zeros(size(img));
    
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            
            % draw square subset
            minK = max([1,i - ceil(R_window)]);
            minL = max([1,j - ceil(R_window)]);

            maxK = min([size(img,1),i + ceil(R_window)]);
            maxL = min([size(img,2),j + ceil(R_window)]);
            
%             local = [];

            local = img(minK:maxK,minL:maxL);
            
            % now consider local region around pixel
%             for k = minK:maxK
%                 for l = minL:maxL
%                     if (k-i)^2 + (l-j)^2 <= R_window^2
%                         local = [local, img(k,l)];
%                     end
%                 end
%             end
            
            % apply normalisation
%             newImg(i,j) = (img(i,j) - mean(local(:)))/std(local(:));
            newImg(i,j) = (img(i,j) - mean(local(:)))/max([std(local(:)),20]);
            
            
        end
    end
    
end
