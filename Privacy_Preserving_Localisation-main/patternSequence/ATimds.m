classdef ATimds
    properties
        BF (1,1) {mustBeNumeric}
        imds
    end
    methods
        function obj = ATimds(path, BF, varargin)
            if nargin == 1
                BF = 1;
            end
            obj.imds = imageDatastore(path, varargin{:});
            obj.BF = BF;
        end

        function img = readimage(self, imgIdx)
            img = readimage(self.imds,imgIdx);
%             img = im2double(img);
            img = self.BF*img;
%             img(img > 1) = 1;
        end

        function self = subset(self, slices)
            self.imds = subset(self.imds, slices);
        end

        function obj = bagOfFeatures(self, varargin)
            obj = bagOfFeatures(self.imds, varargin{:});
        end

        function idx = indexImages(self, bag, varargin)
            idx = indexImages(self.imds, bag, varargin{:});
        end

        function n = numel(self)
            n = length(self.imds.Files);
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


