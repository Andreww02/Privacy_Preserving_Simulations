function convs = runEdges(img,edgeAngles,hsize)
    convs = zeros(size(img,1),size(img,2),length(edgeAngles));
    for i = 1:length(edgeAngles)
%         mask = getEdgeMask(hsize,edgeAngles(i));
        mask = getEdgeMaskIntegrate(hsize,edgeAngles(i));
        convs(:,:,i) = conv2(img,mask,'same');
    end
end