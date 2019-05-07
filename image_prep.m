% Prepares the image for inpainting.

downsample = true;
k = 1;

% Read in the image from the paper and extract (a) and (b)
f = imread('full_image.gif');
a = f(5:695, 1:600);
b = f(5:695, 630:1229);

% Define the missing region in (b) and use to filter (a)
mask_val = b(293, 275);
M = (b == mask_val);
a(a==0) = 1;
a(M) = 0; % not sure if this is required or not

if downsample
   % resize
   a = imresize(a, 0.25);
   % fix regions that go to 0 outside of unknown region
   xs = [34, 32, 33, 33, 38, 35, 40, 50, 52, 53, 56];
   ys = [17, 41, 53, 54, 14, 41,  9, 13, 13, 13, 41];
   a(xs, ys) = 1;
   % add additional k pixels to unknown region to account for downsampling
   for i = 1:k
       mask = 1-(a==0);
       bound = bwperim(mask, 8);
       bound(1, :) = 0; bound(:, 1) = 0; bound(end, :) = 0; bound(:, end) = 0;
       a(a==0 | bound) = 0;
   end
   M = (a==0);
end

% Set I (the working image)
I = a;
% Invert M to match the definition in the paper
M = 1-M;

clear f a b mask_val;