idx = idx + 1; % iterate 
frame = getframe(gcf);
im = frame2im(frame);
[A, map] = rgb2ind(im,256);
if idx == 1
    imwrite(A, map, filename, 'gif', 'LoopCount', Inf, 'DelayTime', 2);
else
    imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 2);
end