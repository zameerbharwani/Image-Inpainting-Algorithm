comp_fig = figure;
l_vals = [5,9,13,17];
for plot_ind = 1:length(l_vals)
    lambda = l_vals(plot_ind);
    main
    figure(comp_fig)
    ax{plot_ind} = subplot(2,2,plot_ind);
    imshow(I)
end

title(ax{1},['\lambda = ' num2str(l_vals(1))]);
title(ax{2},['\lambda = ' num2str(l_vals(2))]);
title(ax{3},['\lambda = ' num2str(l_vals(3))]);
title(ax{4},['\lambda = ' num2str(l_vals(4))]);
