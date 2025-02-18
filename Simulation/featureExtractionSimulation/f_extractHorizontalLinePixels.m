function pixelValues = f_extractTwoPointPixels(img)
    % EXTRACTTWOPOINTPIXELS Extract pixel values of two random points on the same horizontal line.
    %
    % Inputs:
    %   img - Input image (grayscale or RGB)
    %
    % Outputs:
    %   pixelValues - Pixel values of the two random points
    
    % Validate input
    if isempty(img)
        error('Input image is empty.');
    end
    
    % Get image dimensions
    [rows, cols, ~] = size(img);
    
    % Generate a random row (horizontal line)
    randomRow = randi(rows);
    
    % Generate two random points in the same row
    col1 = randi(cols);
    col2 = randi(cols);
    
    % Extract pixel values of the two points
    if size(img, 3) == 1
        % Grayscale image
        pixelValue1 = img(randomRow, col1);
        pixelValue2 = img(randomRow, col2);
    else
        % RGB image
        pixelValue1 = squeeze(img(randomRow, col1, :));
        pixelValue2 = squeeze(img(randomRow, col2, :));
    end
    
    % Combine the two pixel values into one output
    pixelValues = [pixelValue1, pixelValue2];
    
    % Plot the image and mark the selected points
    figure;
    imshow(img, []);
    hold on;
    plot([col1, col2], [randomRow, randomRow], 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    hold off;
    title('Selected Points on the Horizontal Line');
    
    % Display the pixel values
    disp('Extracted Pixel Values:');
    disp(pixelValues);
end
