I = uint8(I);
imshow(I);
set(gcf, 'Position',  [200, 200, 1000, 1000])
I = double(I);
hold on;
bl = [xp+(m-1)/2, yp-(m-1)/2];
br = [xp+(m-1)/2, yp+(m-1)/2];
tl = [xp-(m-1)/2, yp-(m-1)/2];
tr = [xp-(m-1)/2, yp+(m-1)/2];
targetx = [ones(1,m)*bl(1), ones(1,m)*tl(1), tl(1):bl(1), tr(1):br(1)];
targety = [bl(2):br(2), tl(2):tr(2), ones(1,m)*tl(2), ones(1,m)*tr(2)];
plot(targety, targetx, 'r', 'LineWidth', 2);
for j = 1:lambda
    bl = [xq(j)+(m-1)/2, yq(j)-(m-1)/2];
    br = [xq(j)+(m-1)/2, yq(j)+(m-1)/2];
    tl = [xq(j)-(m-1)/2, yq(j)-(m-1)/2];
    tr = [xq(j)-(m-1)/2, yq(j)+(m-1)/2];
    targetx = [ones(1,m)*bl(1), ones(1,m)*tl(1), tl(1):bl(1), tr(1):br(1)];
    targety = [bl(2):br(2), tl(2):tr(2), ones(1,m)*tl(2), ones(1,m)*tr(2)];
    plot(targety, targetx, 'b', 'LineWidth', 2);
end
title(['Iteration ' num2str( i )]);
if pause_type == 1
    pause(0.5);
elseif pause_type == 2
    disp('Press any key to continue');
    pause;
elseif pause_type == 3
    pause(0.01);
end
% code for creating gif
if make_gif
    create_gif;
end
