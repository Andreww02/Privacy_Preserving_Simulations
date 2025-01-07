function A = matrixCoordsInterpolate(horiz,vert)
    % look at which combination of local intercepts there is and hence find
    % area of triangle
    A = nan;
    
    if sum(isnan(horiz)) == 0 && sum(isnan(vert)) == 0
        % we have no nan's so the line goes through both corners, hence the
        % area is half 
        A = 1/2;
    elseif sum(isnan(horiz)) == 1 && sum(isnan(horiz)) == 1
        % we have a triangle with a shared corner with the square
        % 4 possible cases
        if isnan(horiz(1))
            if isnan(vert(1))
                % corner in common is top right
                A = 0.5*(0.5 - horiz(2))*(0.5 - vert(2));
            elseif isnan(vert(2))
                % corner in common is top left
                A = 0.5*(horiz(2) + 0.5)*(0.5 - vert(1));
            end
        elseif isnan(horiz(2))
            if isnan(vert(1))
                % corner in common is bottom right
                A = 0.5*(0.5 - horiz(1))*(0.5 + vert(2));
            elseif isnan(vert(2))
                % corner in common is bottom left
                A = 0.5*(horiz(1) + 0.5)*(0.5 + vert(1));
            end
        end
    elseif sum(isnan(horiz)) == 2 && sum(isnan(horiz)) == 0
        % we have trapz
    end
    
end