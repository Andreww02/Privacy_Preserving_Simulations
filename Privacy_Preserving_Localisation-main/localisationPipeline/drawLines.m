function drawLines(linesStruct)
    
    for lineIdx = 1:length(linesStruct)
        tVals = linesStruct(lineIdx).tBound;
        hold on
        for tIdx = 1:length(tVals)
            coord(tIdx,:) = linesStruct(lineIdx).point + tVals(tIdx)*linesStruct(lineIdx).dir;
        end
        ATplot(coord(:,1), coord(:,2))
        set(gca,'XScale','linear')
    end
%     set(gca,'ColorOrderIndex',1)
%     for lineIdx = 1:length(linesStruct)
%         ATplot(linesStruct(lineIdx).point(1), linesStruct(lineIdx).point(2),'rx')
%     end

end