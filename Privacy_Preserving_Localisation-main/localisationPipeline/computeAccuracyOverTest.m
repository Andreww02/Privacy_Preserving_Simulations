function acc = computeAccuracyOverTest(testImageIdxes,estimatedIdx, bound)
    % todo: work with cyclic datasets
    differenceIdxes = abs(testImageIdxes- estimatedIdx);

    acc = sum(differenceIdxes < bound)/ length(differenceIdxes);
end