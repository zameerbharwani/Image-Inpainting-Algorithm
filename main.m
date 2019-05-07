% Main function for running the inpainting results for ECE417 final project
% by Thomas Akdeniz, Zameer Bharwani, and Kristoff Malejczuk.

clc; clear all; close all

show_progress = false; % whether to display the image after each iteration
make_gif = false; % whether to create gif (show_progress must also be true)
filename = 'iterations.gif';  % gif filename
pause_type = 3;
idx = 0; % counter for gif
% 1 for 'timed', 2 for 'keypress', 3 for 'none'

% Define variables
m = 11; % dimension of image patches [5, 17]
lambda = 5; % number of candidate patches
s = 2; % Gaussian filter standard deviation [1.5, 2.5]
max_i = 1000; % maximum number of iterations for safety
alph = 0.2; % alpha value for alpha mean

% Run the image_prep script to obtain I and M
image_prep2;
% Cast I to double for calculations
I = double(I);

% While there are still unknown pixels...
i = 0;
tic;
% while sum(M == 0, 'all') > 0
while sum(sum(M == 0)) > 0
    % Update iteration variable
    i = i + 1;
    % Compute the next target region
    [xp, yp] = find_target_patch(I, M, m);
    % Compute the canidate regions
    [xq, yq] = find_can_patches(I, M, xp, yp, m, lambda, s);
    if show_progress
        progress_update
    end
    % Inpaint the image
    [I, M] = inpaint_target(I, M, xp, yp, xq, yq, m, alph);
    
    % Safety check on max iterations
    if i >= max_i
        disp('Maximum iterations reached');
        break
    end
end

fprintf('Calculations completed after %d iterations and %d seconds.\n', i, toc);

hold off
% Cast image to uint8 for imshow
I = uint8(I);
imshow(I);

% add final image to gif (if gif was desired by user)
if show_progress
    if make_gif
        frame = getframe(gcf);
        im = frame2im(frame);
        [A, map] = rgb2ind(im,256);
        imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 2);
    end
end
