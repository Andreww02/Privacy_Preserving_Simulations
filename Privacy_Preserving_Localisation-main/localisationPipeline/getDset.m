function [dset] = getDset(path, NameValueArgs)
    arguments 
        path (1,1) string
        NameValueArgs.brightnessFact = 1; % amount to scale the brightness by
    end

    dset.imageSet = imageDatastore(path,'LabelSource','foldernames','IncludeSubfolders',true);
    dset.path = path;

    dset.brightnessFact = 1;

    % remove everything after data and call that the name of the dset
    tmp = path(strfind(dset.path,'data') + length('data') + 1:end);
    dset.name = strrep(fullfile(tmp),'\','_');

    img = readimage(dset.imageSet,1);
    dset.imsize = size(img);
    dset.nImgs = size(dset.imageSet.Files,1);
end