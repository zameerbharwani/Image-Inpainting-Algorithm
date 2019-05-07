% Prepares the new image for inpainting.

k = 2;
downsample = 0.3;

% Read in the image in grayscale
f = rgb2gray(imread('no_tree.jpg'));
% Threshold to handle MS paint not painting all pixels at 255
f(f>240) = 255;
% Create mask
M = (f == 255);
% Manually fix mask
M(281:389, 513:734) = 0;
M(354, 443) = 1;
f(M) = 0;

% resize
f = imresize(f, downsample);
% add additional k pixels to unknown region to account for downstampling
for i = 1:k
   mask = 1-(f==0);
   bound = bwperim(mask, 8);
   bound(1, :) = 0; bound(:, 1) = 0; bound(end, :) = 0; bound(:, end) = 0;
   f(f==0 | bound) = 0;
end
M = (f==0);

% Set I (the working image)
I = f;
% Invert M to match the definition in the paper
M = 1-M;

clear f;