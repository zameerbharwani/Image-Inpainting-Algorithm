function [xp, yp] = find_target_patch(I,M,m)
%FIND_TARGET_PATCH finds the next target patch
%
%   NOTE: ASSUMES MAX INTENSITY IS 255
%
%   Parameters
%   ----------
%   I : 2D array
%       A grayscale image with missing pixels as -1.
%   M : 2D array
%       A binary image the same size as I with 0 for missing pixels and 1
%       for known pixels.
%   m : int
%       The dimensions of the target patch.
%
%   Returns
%   -------
%   [xp, yp] : ints
%       The center point coordinates of the next target patch.
Imax = 255;
offset = (m-1)/2;

% Find the bounary d_phi
d_psi = bwperim(M, 8);% connectivity of 8 to match paper
% remove the incorrect bounary added by bwperim
d_psi(1, :) = 0; d_psi(:, 1) = 0; d_psi(end, :) = 0; d_psi(:, end) = 0;

% Create iteration list for d_phi and preallocate P
[kx, ky] = find(d_psi);
P = zeros(length(kx), 1);

% loop through points on d_phi
for i = 1:length(kx)
    x = kx(i); y = ky(i);
    % Calculate confidence term using the mask
%     C = sum(M(x-offset:x+offset, y-offset:y+offset), 'all') / m^2;
    C = sum(sum(M(x-offset:x+offset, y-offset:y+offset))) / m^2;
    % Calculate data term
    % 1) calculate isophote vector
    % note the slightly different definition to match row,col indexing
    IP = 1/(2*Imax) * [I(x-1,y)-I(x+1,y),I(x,y+1)-I(x,y-1)];
    % 2) calculate n vector
    n0 = [M(x,y+1)-M(x,y-1),M(x+1,y)-M(x-1,y)];
    if isequal(n0, [0 0])
        n = [0 0];
    else
        n = n0 / norm(n0);
    end
    % 3) Compute D
    D = abs(dot(IP, n)) / Imax; 
    % Calculate priority function and save
    P(i) = C*D;
end

% Use argmax and determine coordinates of Pmax
[~, arg] = max(P);
xp = kx(arg);
yp = ky(arg);

end

