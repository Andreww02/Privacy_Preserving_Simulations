function [keyPt, sigmaIdx] = localizeExtremumViaQuadraticFit(i, j, sigmaIdx, octIdx, nIntervals, DoGimgInOct, ...
                                                                                                    sigma, contrastThreshold, imgBorderWidth, ...
                                                                                                    r, nAttemptsConverge, doSubpixel)
    % note that sigmaIdx is off by one to help calculate cube efficiently
    % quaratic fit to do subpixel location
    
    if doSubpixel
        extOutsideImg = false;
        imgSize = size(DoGimgInOct(:,:,1));
    
        % try to converge to exact extremum
        for attemptIdx = 1:nAttemptsConverge
            cube = DoGimgInOct(i-1:i+1, j-1:j+1, sigmaIdx-1:sigmaIdx+1);
            grad = computeGradAtCenterPixel(cube);
            hess = computeHessianAtCentrePixel(cube);
            extUpdate = -inv(hess)*grad;
    
            % check if we are still within the same pixel
            if max(abs(extUpdate)) < 0.5
                break
            end
    
            % if not, move over to next pixel as needed
            i = i + round(extUpdate(1));
            j = j + round(extUpdate(2));
            sigmaIdx = sigmaIdx + round(extUpdate(3));
    
            % check if outside image
            if (i < imgBorderWidth || i > imgSize(1) - imgBorderWidth ||...
                j < imgBorderWidth || j > imgSize(2) - imgBorderWidth ||...
                sigmaIdx < 2 || sigmaIdx > nIntervals)
                extOutsideImg = true;
                break
            end
        end
    
        % check if keypoint max wasn't found
        if extOutsideImg || attemptIdx == nAttemptsConverge
            keyPt = NaN;
            sigmaIdx = NaN;
            return
        end

        fnValAtExt = cube(2,2,2) + 0.5*dot(grad, extUpdate);
    else
        cube = DoGimgInOct(i-1:i+1, j-1:j+1, sigmaIdx-1:sigmaIdx+1);
        hess = computeHessianAtCentrePixel(cube);
        fnValAtExt = cube(2,2,2);
        extUpdate = [0,0,0];
    end

    % generate keypoint if valid:
    if abs(fnValAtExt)*nIntervals > contrastThreshold
        xyHess = hess(1:2,1:2);
        xyHessTrace = trace(xyHess);
        xyHessDet = det(xyHess);
        % check that point is not too elongate (edge avoidance)
        if xyHessDet > 0 && r*(xyHessTrace^2) < ((r+1)^2)*xyHessDet
            keyPt.pt = [(j + extUpdate(2))*(2^(octIdx - 1)), (i + extUpdate(1))*(2^(octIdx - 1))]; % position
            % note we use sigmaIdx-1 to adjust for index starting at 1
            keyPt.octave = octIdx - 1 + (sigmaIdx - 1)*2^8 + round((extUpdate(3) + 0.5)*255)*2^16;
            keyPt.size = sigma*(2^(((sigmaIdx - 1) + extUpdate(3))/nIntervals))*2^(octIdx-2); % size of feature, oct isnt +1 since index starts at 1
            keyPt.response = abs(fnValAtExt)/255;

            keyPt = SIFTPoints(keyPt.pt, ...
                                            "Metric", keyPt.response, ...
                                            "Scale", keyPt.size,...
                                            "Octave", keyPt.octave);
            return
        end
    end
    keyPt = NaN;
    sigmaIdx = NaN;

end