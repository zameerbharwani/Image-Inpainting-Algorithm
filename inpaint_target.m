function [I_out, M_out] = inpaint_target(I, M, xp, yp, xq, yq, m, alph)
%INPAINT_TARGET inpaints the target patch using the candidate patches
%   Parameters
%   ----------
%   I : N x M array
%       A grayscale image with missing pixels as -1.
%   M : N x M array
%       A binary image the same size as I with 0 for missing pixels and 1
%       for known pixels.
%   [xq, yq] : ints
%       The pixel location of the center of the target patch.
%   [xq, yq] : (1 x lambda) arrays
%       The center points the lambda candidate patches.
%   m : int
%       The dimensions of the target and candidate patches.
%   alph : double
%       The alpha value for the alpha mean.
%
%   Returns
%   -------
%   I_Out : N x M array
%       The inpainted image results
%   M_out : N x M array
%       The updated mask showing which pixels have been inpainted

l = length(xq); % number of candidate patches
offset = (m-1)/2; % offset for indexing patches
trim = floor(alph * l); % alpha trim value for alpha mean
% extract the target patch region from M and I
Mp = M(xp-offset:xp+offset, yp-offset:yp+offset);
Ip = I(xp-offset:xp+offset, yp-offset:yp+offset);

% Create array of candidate patches (vectorize?)
C = zeros(m, m, l);
for j = 1:l
    C(:, :, j) = I(xq(j)-offset:xq(j)+offset, yq(j)-offset:yq(j)+offset);
end

% Sort and trim then find mean for alpha mean
C = sort(C,3);
C = mean(C(:, :, trim:l-trim),3);

% Compute the values masked for only the unknown region
I(xp-offset:xp+offset, yp-offset:yp+offset) = round(C .* (1-Mp) + Ip .* Mp);
% Update the mask
M(xp-offset:xp+offset, yp-offset:yp+offset) = ones(m, m);

I_out = I;
M_out = M;

end

