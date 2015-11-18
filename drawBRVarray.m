function drawBRVarray(session_ibi, good_ind, session_ibi_len)
    colors = get(gca,'colororder');
    colors = [colors; colors; colors; colors];
    close;
    figure(11), hold on;
    set(gca, 'YTick', []);
    axis([0 max(max(session_ibi_len(good_ind(:)))) + 30 0 250]);
    title('Inter-blink interval dynamics extracted while 1st time resting stage')
    figure(12), hold on;
    set(gca, 'YTick', []);
    axis([0 max(max(session_ibi_len(good_ind(:)))) + 30 0 250]);
    title('Inter-blink interval dynamics extracted while 2nd time resting stage')
    figure(13), hold on;
    set(gca, 'YTick', []);
    axis([0 max(max(session_ibi_len(good_ind(:)))) + 30 0 250]);
    title('Inter-blink interval dynamics extracted while IQ testing')
    figure(14), hold on;
    set(gca, 'YTick', []);
    axis([0 max(max(session_ibi_len(good_ind(:)))) + 30 0 250]);
    title('Inter-blink interval dynamics extracted while reading the passage')
    figure(15), hold on;
    set(gca, 'YTick', []);
    axis([0 max(max(session_ibi_len(good_ind(:)))) + 30 0 250]);
    title('Inter-blink interval dynamics extracted while memory testing')
    plot_step = floor(length(good_ind)/ 1.5);

    for i = 1:length(good_ind);
        i
        for k = 1:5
            figure(10 + k), line([0 max(max(session_ibi_len(good_ind(:))))],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
            figure(10 + k), plot(session_ibi{k}{good_ind(i)} + (i-1)*plot_step, 'color', colors(i,:));
            figure(10 + k), text(- 20, (i-1)*plot_step + 2, num2str(i), 'color', colors(i,:));
        end
    end
end