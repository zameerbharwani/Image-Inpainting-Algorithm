comp_fig = figure;
m_vals = [5,9,13,17];
for plot_ind = 1:length(m_vals)
    m = m_vals(plot_ind);
    main
    figure(comp_fig)
    ax{plot_ind} = subplot(2,2,plot_ind);
    imshow(I)
end

title(ax{1},['m = ' num2str(m_vals(1))]);
title(ax{2},['m = ' num2str(m_vals(2))]);
title(ax{3},['m = ' num2str(m_vals(3))]);
title(ax{4},['m = ' num2str(m_vals(4))]);
