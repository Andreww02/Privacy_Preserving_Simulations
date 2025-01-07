function [angle_hist, avg_std_dev] = f_extractStdDeviation(img, num_bins, num_samples)
    % F_ANALYZESTDDEVIATIONBYANGLE Analyzes pixel intensity standard deviation
    % along random lines in an image and bins them by angle.
    %
    % Inputs:
    %   img         - Input grayscale image
    %   num_bins    - Number of bins for angle (e.g., 72 for 5-degree bins)
    %   num_samples - Number of random lines to sample
    %
    % Outputs:
    %   angle_hist  - Histogram of line counts per angle bin
    %   avg_std_dev - Average standard deviation per angle bin

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
    avg_std_dev = zeros(1, num_bins);
    angle_hist = zeros(1, num_bins);
    std_values = zeros(1, num_samples);
    angles = zeros(1, num_samples);

    % Random line sampling and analysis
    for sample_idx = 1:num_samples
        % Select two random points in the image
        point1 = [randi(rows), randi(cols)];
        point2 = [randi(rows), randi(cols)];

        % Calculate the angle between the points
        dy = point2(1) - point1(1);
        dx = point2(2) - point1(2);
        angle = mod(atan2d(dy, dx), 360); % Ensure angle is between 0 and 360
        angles(sample_idx) = angle;

        % Extract pixel values along the line
        line_profile = improfile(img, [point1(2), point2(2)], [point1(1), point2(1)]);

        % Compute the standard deviation of the pixel values
        std_values(sample_idx) = std(double(line_profile));
    end

    % Bin the angles and calculate statistics
    for i = 1:num_bins
        % Indices of angles in the current bin
        bin_indices = (angles >= bin_edges(i)) & (angles < bin_edges(i+1));

        % Compute average standard deviation for the bin
        if any(bin_indices)
            avg_std_dev(i) = mean(std_values(bin_indices));
            angle_hist(i) = sum(bin_indices); % Count of lines in the bin
        else
            avg_std_dev(i) = NaN; % Assign NaN if no values in the bin
        end
    end

    % Plot results
    figure;

    % Histogram of angle counts
    subplot(2, 1, 1);
    bar(binned_angles, angle_hist, 'FaceColor', [0.6 0.8 0.4]);
    xlabel('Angle (degrees)');
    ylabel('Frequency');
    title('Histogram of Angle Counts');
    grid on;
    set(gca, 'XTick', 0:30:360);

    % Average standard deviation vs angle
    subplot(2, 1, 2);
    bar(binned_angles, avg_std_dev, 'FaceColor', [0.2 0.6 0.8]);
    xlabel('Angle (degrees)');
    ylabel('Average Standard Deviation');
    title('Average Standard Deviation vs Angle');
    grid on;
    set(gca, 'XTick', 0:30:360);
end
