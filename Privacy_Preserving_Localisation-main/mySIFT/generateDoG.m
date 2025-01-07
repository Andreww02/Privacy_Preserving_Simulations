function DoG = generateDoG(gImgs)
    % generate difference of gaussian from cell array of matrix stacks

    DoG = {};
    for octIdx = 1:length(gImgs)
        DoG{octIdx} = diff(gImgs{octIdx}, 1, 3);
    end

end