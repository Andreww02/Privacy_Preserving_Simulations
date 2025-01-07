classdef ATimds
    properties
        BF (1,1) {mustBeNumeric}
        imds
    end
    methods
        function obj = ATimds(path, BF)
            if nargin == 1
                BF = 1;
            end
            obj.imds = imageDatastore(path);
            obj.BF = BF;
        end

        function img = readimage(self, imgIdx)
            img = readimage(self.imds,imgIdx);
        end

        function self = subset(self, slices)
            self.imds = subset(self.imds, slices);
        end
    end

end


% classdef ATimds < matlab.io.datastore.ImageDatastore
%     properties
%         BF (1,1) {mustBeNumeric}
%     end
%     methods
%         function obj = ATimds(path, BF)
%             if nargin == 1
%                 BF = 1;
%             end
%             obj@matlab.io.datastore.ImageDatastore(path);
%             obj.BF = BF;
%         end
%     end
% 
% 
% end


