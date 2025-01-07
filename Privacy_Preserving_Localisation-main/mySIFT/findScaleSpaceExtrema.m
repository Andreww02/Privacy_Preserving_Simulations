function keypts = findScaleSpaceExtrema(gImgs, DoGimgs, nIntervals, sigma, imgBorderWidth, contrastThreshold, doSubpixel)

    r = 10; % eigenvalue ratio to determine a max
    nAttemptsConverge = 5;
    threshold = floor(0.5 * contrastThreshold / nIntervals * 255);

    keypts = false;
    % loop over octaves:
    for octIdx = 1:length(DoGimgs)
        DoGimgsInOct = DoGimgs{octIdx};
        
        % compute minima, maxima and apply contrast thresholding
        thresholdVals = abs(DoGimgsInOct) > threshold;

        connectedness = 26;
        DoGmax = or(and(imregionalmax( DoGimgsInOct, connectedness), thresholdVals),...
                               and(imregionalmax(-DoGimgsInOct, connectedness), thresholdVals));


        % loop over all true values
        % outermost loop over DoG img stack D(x,y,sigma)
        for sigmaIdx = 1:(size(DoGmax,3)-2)
            for i = imgBorderWidth:(size(DoGmax,1)-imgBorderWidth)
                for j = imgBorderWidth:(size(DoGmax,2)-imgBorderWidth)
                    % check value is true
                    if DoGmax(i, j, sigmaIdx)
                        % 
                        [keyPt,keyPtsigIdx] = localizeExtremumViaQuadraticFit(i, j, sigmaIdx + 1, octIdx, nIntervals, DoGimgsInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge, doSubpixel);
                        if isa(keyPt,'SIFTPoints')
                            fprintf('%d, %d, %d\n',i,j,sigmaIdx);
                            keyPtwithOrientations = computeKeypointsWithOrientations(keyPt, octIdx, gImgs{octIdx}(:,:,keyPtsigIdx));
%                             keyPtwithOrientations = keyPt;
                            % check if first keypt
                            if ~isa(keypts,'SIFTPoints')
                                keypts = keyPtwithOrientations;
                            else
                                keypts = [keypts; keyPtwithOrientations];
%                                 if length(keypts) == 10
%                                     return
%                                 end
                            end
                        end
                    end
                end
            end
        end
    end
end