function n = computeNumberOfOctaves(imgSize)
    n =  round(log(min(imgSize)) / log(2) - 1);
end