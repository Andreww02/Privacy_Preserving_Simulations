function [maxVal, minVal] = GenerateCircle(img, centerX, centerY, radius)

    theta = linspace(0, 2*pi, 360); % in radians 
    x = centerX + radius * cos(theta);
    y = centerY + radius * sin(theta);

    %find intensity values
    intensity_values = interp2(img, x, y);

    maxVal = max(intensity_values);
    minVal = min(intensity_values);
end
