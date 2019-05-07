function [xq, yq] = find_can_patches(I, M, xp, yp, m, lambda, s)
%FIND_CAN_PATCHES finds the associated candidate patches
%   Parameters
%   ----------
%   I : 2D array
%       A grayscale image with missing pixels as -1.
%   M : 2D array
%       A binary image the same size as I with 0 for missing pixels and 1
%       for known pixels.
%   [xp, yp] : ints
%       The pixel location of the center of the target patch
%   m : int
%       The dimensions of the target and candidate patches.
%   lambda : int
%       The number of candidate patches to return.
%   s : double
%       Gaussian filter standard deviation
%
%   Returns
%   -------
%   [xq, yq] : (1 x lambda) arrays
%       The center points the lambda candidate patches.

% Set the h value
h = 34;
% Determine center coordinates of target patch
offset = (m-1)/2; % calcualte offset from center of patch to edge
Mp = M(xp-offset:xp+offset, yp-offset:yp+offset); % M for target patch
[xk, yk] = find(Mp); % returns the indicies of all known pixels
x1 = mean(xk); y1 = mean(yk); % averaging for known center
[xu, yu] = find(Mp==0); % returns the indicies of all unknown pixels
x0 = mean(xu); y0 = mean(yu); % averaging for unknown center
c = round([(x1+x0)/2, (y1+y0)/2]); % geographic center of region
xc = c(1); yc = c(2);

% Calculate Gaussian filter for the target region
[Y, X] = meshgrid(1:m, 1:m); % generate mesh for vectorized Gaussian calc
G = exp(-((X-xc).^2+(Y-yc).^2)/(2*s^2)); % calculate G

% find image size and create arrays for the NLTS at each pixel and the
% center coords
[r,c] = size(I);
scores = [];
coordinates_x = [];
coordinates_y = [];

% Extract the target patch
Ip = I(xp-offset:xp+offset, yp-offset:yp+offset);

for cp_r = ceil(m/2):r-floor(m/2) % cp_r = center pixel row co-ordinate of candidate patch. The bounds of the for loop ensure we have only full overlaps
    for cp_c = ceil(m/2):c-floor(m/2) % cp_c = center pixel column co-ordinate of candidate patch. The bounds of the for loop ensure we have only full overlaps
        Mc = M(cp_r-offset:cp_r+offset, cp_c-offset:cp_c+offset); % extract M for the canidate region
%         if sum(Mc, 'all') == m^2 % making surepsi_Q intersect omega = empty set
        if sum(sum(Mc)) == m^2 % making surepsi_Q intersect omega = empty set
            % Extract candidate patch
            Iq = I(cp_r-offset:cp_r+offset, cp_c-offset:cp_c+offset);
            % Set pixels within the unknown region to 0 to remove their contribution to the norm
            Iq = Iq.*Mp;
            % Calculate NLTS
            NLTS = exp(-1*norm((Ip-Iq).^2 .* G, 1)/h^2);
            % Save values in arrays
            scores = [scores, NLTS]; 
            coordinates_x = [coordinates_x, cp_r];
            coordinates_y = [coordinates_y,cp_c];
        end
    end
end

% Use sort to extract the lambda largest values
[~, sortIdx] = sort(scores,'descend');
coordinates_x = coordinates_x(sortIdx);
coordinates_y = coordinates_y(sortIdx);
xq = coordinates_x(1:lambda);
yq = coordinates_y(1:lambda);

end

