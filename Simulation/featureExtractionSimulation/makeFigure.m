%% Setup the dataset and parameters
clear;
clc;
close all;

% Define your dataset path.
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsons";
dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\rot";
% Load your dataset (assuming getDset returns the dataset in an appropriate format).
dset = getDset(dsetPath);

% Define indices for each row:
%   Row 1: index 49
%   Row 2: index 75
%   Row 3: index 75 (rotated 90°)
rowIndices = [49, 117, 117];

% Parameters for the first histogram generation (Column 2: "Ours")
numLines       = 10000;
lineLength     = 150;
numBinsFeature = 250;
numBinsAngle   = 250;

% Parameters for the max-min histogram (Column 3: "Previous")
nCircles    = 3000;      % Number of random circles to sample
radii       = [20, 50];   % [minRadius, maxRadius]
nSample     = 50;        % Number of sample points per circle
isNormalise = false;     % Change to true if you want to normalize
numBinsMax  = 255;       % Number of bins for the maximum values
numBinsMin  = 255;       % Number of bins for the minimum values

% We'll use a 4x3 grid to incorporate the residual plots in the 4th row.
figure;

% Preallocate variables to store histogram outputs for residual computation.
counts_ours_row2 = [];
counts_ours_row3 = [];
counts_prev_row2 = [];
counts_prev_row3 = [];

% Also store bin edges from the histogram functions for proper plotting.
angleEdges_store = [];
featureEdges_store = [];
binEdgesMax_store = [];
binEdgesMin_store = [];

%% Create the 4x3 grid of subplots
for i = 1:12
    ax = subplot(4,3,i);  % 4 rows x 3 columns grid
    row = ceil(i/3);      % Row number: 1, 2, 3, or 4
    col = mod(i-1, 3) + 1;% Column number: 1 (left), 2 (middle), 3 (right)
    
    if row <= 3
        % For rows 1-3, follow your existing procedure.
        idx = rowIndices(row);
        img = f_displayImageFromDset(dset, idx);
        if size(img, 3) > 1
            img = rgb2gray(img);
        end
        if row == 3
            % For row 3, flip the image horizontally.
            img = fliplr(img);
        end
        
        if col == 1
            % First column: show the actual image.
            imshow(img, [], 'Parent', ax);
        elseif col == 2
            % Second column: show the "ours" histogram using f_generateHistogram.
            [angles, sumDerivativesLogNorm, angleEdges, featureEdges, counts] = ...
                f_generateHistogram(ax, img, numLines, lineLength, numBinsFeature, numBinsAngle);
            % Save the counts for residual computation.
            if row == 2
                counts_ours_row2 = counts;
                angleEdges_store = angleEdges;
                featureEdges_store = featureEdges;
                ylabel(ax, 'Line Angle (degrees)');
            elseif row == 3
                counts_ours_row3 = counts;
            end
        elseif col == 3
            % Third column: show the "previous" max-min histogram.
            [maxVals, minVals, binEdgesMax, binEdgesMin, counts] = ...
                f_generateMaxMinHistogram(ax, img, nCircles, radii, nSample, isNormalise, numBinsMax, numBinsMin);
            if row == 2
                counts_prev_row2 = counts;
                binEdgesMax_store = binEdgesMax;
                binEdgesMin_store = binEdgesMin;
                ylabel(ax, 'Min Intensity');
            elseif row == 3
                counts_prev_row3 = counts;
            end
        end
        
        % (Optional: Adjust axis labels for rows 2 & 3 here as needed.)
        
    elseif row == 4
        % Row 4: Create residual plots.
        if col == 1
            % Leave the first column blank.
            axis(ax, 'off');
        elseif col == 2
            % Residual for "Ours": Difference between row2 and row3 histograms.
            if ~isempty(counts_ours_row2) && ~isempty(counts_ours_row3)
                rawResidual_ours = counts_ours_row2 - counts_ours_row3;
                maxAbsVal_ours = max(abs(rawResidual_ours(:)));
                normalizedResidual_ours = rawResidual_ours / maxAbsVal_ours;

                imagesc(featureEdges_store(1:end-1), angleEdges_store(1:end-1), normalizedResidual_ours');
                set(ax, 'YDir', 'normal');
                % Set axis limits to match the histogram's bin ranges.
                % ylim(ax, [min(angleEdges_store), max(angleEdges_store)]);
                % xlim(ax, [min(featureEdges_store), max(featureEdges_store)]);
                colorbar(ax);
                clim([-1 1]);
                % ylabel(ax, 'Line Angle (degrees)');
                xlabel(ax, 'Normalised Sum of Derivatives');
                title(ax, 'Normalised Residual: Ours');
            else
                text(0.5, 0.5, 'No data', 'HorizontalAlignment', 'center');
            end
        elseif col == 3
            % Residual for "Previous": Difference between row2 and row3 max-min histograms.
            if ~isempty(counts_prev_row2) && ~isempty(counts_prev_row3)
                rawResidual_prev = counts_prev_row2 - counts_prev_row3;
                maxAbsVal_prev = max(abs(rawResidual_prev(:)));
                normalizedResidual_prev = rawResidual_prev / maxAbsVal_prev;
                imagesc(binEdgesMax_store(1:end-1), binEdgesMin_store(1:end-1), normalizedResidual_prev');
                set(ax, 'YDir', 'normal');
                xlim(ax, [0 255]);
                ylim(ax, [0 255]);
                colorbar(ax);
                clim([-1 1]);
                xlabel(ax, 'Max Intensity');
                
                % ylabel(ax, 'Min Intensity');
                title(ax, 'Normalised Residual: Previous');
            else
                text(0.5, 0.5, 'No data', 'HorizontalAlignment', 'center');
            end
        end
    end
end

%% Add Column Titles using Annotations
% First column remains untitled.
annotation('textbox', [0.33, 0.93, 0.34, 0.04], 'String', 'Ours', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
annotation('textbox', [0.64, 0.93, 0.33, 0.04], 'String', 'Previous', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');