function vidToImgFolder(vidInfo, targetInfo, NameValueArgs)
    arguments
        vidInfo
        targetInfo

        NameValueArgs.convertToGray double {islogical} = true
        NameValueArgs.targetFormat string = '.png'

    end

    assert(exist(vidInfo.path,"dir"))
    assert(exist(fullfile(vidInfo.path, strcat(vidInfo.fname, vidInfo.format)),"file"))

    infoSaveLoc = fullfile(targetInfo.path,vidInfo.fname,'dsetInfo.mat');
    imgSaveLoc = fullfile(targetInfo.path,vidInfo.fname,'imgs');
    if ~exist(imgSaveLoc,"dir")
        mkdir(imgSaveLoc);
    end

    vid = VideoReader(fullfile(vidInfo.path,strcat(vidInfo.fname, vidInfo.format)));

    ii=1;
    while hasFrame(vid)
        img = readFrame(vid);
        
        if NameValueArgs.convertToGray
            img = im2gray(img);
        end
        
        filename = strcat(sprintf('%05d',ii), NameValueArgs.targetFormat);
        fullname = fullfile(imgSaveLoc,filename);
        imwrite(img,fullname)    
        ii = ii+1;
    end

    % save some info about the dataset too
    dset.imsize = [vid.Height, vid.Width];
    dset.path = fullfile(targetInfo.path,vidInfo.fname,'imgs');
    dset.nImgs = vid.NumFrames;
    dset.frameRate = vid.FrameRate;

    save(infoSaveLoc, 'dset');

end