function acc = testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, visualiseImageIdxs, extractor, isPlotting, isVerbose)

    if nargin == 6
        isPlotting = true;
    end
    if nargin <=7
        isVerbose = true;
    end

    imageSet = imageDatastore(dset.path,'LabelSource','foldernames','IncludeSubfolders',true);

    trainIdx = 1:trainingSubsetSkip:numel(imageSet.Files);
    imageSubSet = subset(imageSet,trainIdx);
    
    %Pick a random subset of the flower images.
    trainingSet = splitEachLabel(imageSubSet, 0.9999, 'randomized');
    
    % Create a custom bag of features using the 'CustomExtractor' option.
    bag = bagOfFeatures(trainingSet, ...
        'CustomExtractor', extractor, ...
        'TreeProperties', [numLevels numBranches],...
        'Verbose', isVerbose);
    
    
    % Create a search index.
    ImageIndex = indexImages(imageSubSet,bag,'SaveFeatureLocations',false);
    
    if isPlotting
        for imgIdx = visualiseImageIdxs
            % Define a query image
            queryImage = readimage(imageSet,imgIdx);
            
            
            figure
            imshow(queryImage)
            
            % Search for the top 5 images with similar color content
            [imageIDs, ~] = retrieveImages(queryImage, ImageIndex,'NumResults',5);
            
            % Display results using montage. 
            figure
            montage(imageSubSet.Files(imageIDs),'ThumbnailSize',[200 200])
        end
    end

    % seq slam like plots for guessed positon
    testImageIdxes = 1:1:numel(imageSet.Files);
    estimatedIdx = zeros(size(testImageIdxes));

    for i = 1:length(testImageIdxes)
        testImage = readimage(imageSet,testImageIdxes(i));
        [imageIDs, ~] = retrieveImages(testImage, ImageIndex,'NumResults',1);
        if ~isempty(imageIDs)
            estimatedIdx(i)  = trainIdx(imageIDs);
        else 
            estimatedIdx(i) = nan;
        end
    end

    if isPlotting
        figure
        plot(testImageIdxes, estimatedIdx,'x','MarkerSize',8)
        hold on
    
        ATplot(testImageIdxes, testImageIdxes,'r')
        xlabel('Test image index','Interpreter','latex')
        ylabel('Estimated image index','Interpreter','latex')
        tmp = ylim;
        plot(testImageIdxes, testImageIdxes+1.5*trainingSubsetSkip,'k')
        plot(testImageIdxes, testImageIdxes-1.5*trainingSubsetSkip,'k')
        ylim(tmp);
    
        figure
        histogram(testImageIdxes- estimatedIdx);
    end


    acc = computeAccuracyOverTest(testImageIdxes, estimatedIdx,1.5*trainingSubsetSkip);
    fprintf('Accuracy of extractor: %.3f\n', 100*acc);

end