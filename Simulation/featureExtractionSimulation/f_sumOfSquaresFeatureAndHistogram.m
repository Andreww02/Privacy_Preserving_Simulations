function f_sumOfSquaresFeatureAndHistogram(img, num_bins, num_samples, lineLength, hist_type)
    % F_SUMOFSQUARESFEATUREANDHISTOGRAM
    % Computes the sum of squares of the first derivative along random
    % lines and visualizes the feature using a histogram.
    %
    % Inputs:
    %   img         - Input grayscale image
    %   num_bins    - Number of bins for angle (e.g., 72 for 5-degree bins)
    %   num_samples - Number of random line samples
    %   lineLength  - Length of each random line (in pixels)
    %   hist_type   - Type of histogram ('1d' or '2d')
    %
    % Example:
    %   f_sumOfSquaresFeatureAndHistogram(img, 72, 2000, 50, '1d');

    % Validate input image and convert to grayscale if needed
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    [rows, cols] = size(img); % Get image dimensions

    % Parameters for binning
    bin_width = 360 / num_bins; % Width of each bin in degrees
    bin_edges = 0:bin_width:360; % Edges of the bins
    binned_angles = (bin_edges(1:end-1) + bin_edges(2:end)) / 2; % Bin centers

    % Initialize storage
    sum_of_squares = zeros(1, num_samples);
    angles = zeros(1, num_samples);

    % Generate random lines
    lines = f_generateRandomLines([rows, cols], num_samples, lineLength);

    % Feature computation
    for sample_idx = 1:num_samples
        % Extract the start and end points of the current line
        startPoint = lines(sample_idx).start;
        endPoint = lines(sample_idx).end;

        % Calculate the angle between the points
        dy = endPoint(2) - startPoint(2);
        dx = endPoint(1) - startPoint(1);
        angle = mod(atan2d(dy, dx), 360); % Ensure angle is between 0 and 360
        angles(sample_idx) = angle;

        % Extract pixel values along the line
        line_profile = improfile(img, [startPoint(1), endPoint(1)], [startPoint(2), endPoint(2)]);

        % Compute the sum of squares of the first derivative
        if numel(line_profile) > 1 % Ensure there are enough points
            first_derivative = diff(double(line_profile));
            sum_of_squares(sample_idx) = sum(first_derivative.^2);
        else
            sum_of_squares(sample_idx) = 0; % Handle edge cases with short lines
        end
    end

    % Create the histogram
    figure;
    if strcmp(hist_type, '1d')
        % 1D Histogram: Average sum of squares vs angle
        averaged_sum = zeros(1, num_bins);
        for i = 1:num_bins
            % Indices of angles in the current bin
            bin_indices = (angles >= bin_edges(i)) & (angles < bin_edges(i+1));

            % Compute average sum of squares for the bin
            if any(bin_indices)
                averaged_sum(i) = mean(sum_of_squares(bin_indices));
            else
                averaged_sum(i) = NaN; % Assign NaN if no values in the bin
            end
        end

        % Plot 1D histogram
        bar(binned_angles, averaged_sum, 'FaceColor', [0.2 0.6 0.8]);
        xlabel('Angle (degrees)');
        ylabel('Average Sum of Squares');
        title('1D Histogram: Angle vs Sum of Squares');
        grid on;
        set(gca, 'XTick', 0:30:360);

    elseif strcmp(hist_type, '2d')
        % 2D Histogram: Angle vs Sum of Squares
        histogram2(angles, sum_of_squares, [num_bins, num_bins], ...
                   'DisplayStyle', 'tile', 'EdgeColor', 'none');
        xlabel('Angle (degrees)');
        ylabel('Sum of Squares');
        zlabel('Frequency');
        title('2D Histogram: Angle vs Sum of Squares');
        colorbar;
    else
        error('Invalid hist_type. Choose ''1d'' or ''2d''.');
    end
end