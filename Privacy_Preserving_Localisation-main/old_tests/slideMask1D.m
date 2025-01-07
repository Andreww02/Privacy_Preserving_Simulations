function [vec,newImg] = slideMask1D(img,mask,isRowSlide)
    % slide mask over the img rows (isRowSlide = true) or columns (isRowSlide = false)
    % and max hold over the loop, returning in vector of size(img,1) or
    % size(img,2)
    
    newNRows = size(img,1) - mask.size + 1;
    newNCol = size(img,2) - mask.size + 1;
    
    if isRowSlide
        vec = zeros(newNRows,1);
        
        for i = 1:newNRows
            vec(i) = 0;
            for j = 1:newNCol
                smallerImg = img(i:i + mask.size - 1,j:j + mask.size - 1);
                
                % sum of products
                maskedValue = sum(mask.values.*smallerImg,'all');
                
                newImg(i,j) = maskedValue;
                
                % max hold
                if maskedValue > vec(i)
                    vec(i) = maskedValue;
                end
                
            end
        end
        
    else
        vec = zeros(size(img,2) - mask.size,1);
    end

    
end