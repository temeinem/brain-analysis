function [ibli maxtab] = extract_ibli(signal, samplingrate)
    length_threshold = samplingrate / 50;
    minimum_blink_range = samplingrate/ 25;
     %plot_range = 125*samplingrate:155*samplingrate;%length(signal);
    plot_range = 1:length(signal);
%   figure('Position', [100, 100, 540, 257]), hold on, plot(plot_range/250, signal(plot_range)); title('');
    zero_ind = find(signal < std(signal));
    signal(zero_ind) = 0;
    %figure('Position', [100, 100, 540, 257]), hold on, plot(plot_range, corrected(plot_range)); title('Samples less than \sigma are removed');
    %% (1) Detect the beginning and the end of the range of a blink candidate 
    % (a) Find the beginning of each beat
    nzi = find(signal ~= 0);
    nzi_dif = nzi(2:end) - nzi(1:end-1);
    nzi_dif = [0 nzi_dif]; %add non-one value to include first beat
    beat_begins = nzi(find(nzi_dif ~= 1)); %nzi(find(nzi_dif ~= 1) + 1)
    % (b)  Find widths of blink range candidates
    beat_width = [];
    for i = 1:length(beat_begins)
        beat_width(i) = 0;
        for j = 1:length(signal) - i
            if(beat_begins(i) + j > length(signal)) %refactor
                break;
            end
            if(signal(beat_begins(i) + j) ~= 0)
                beat_width(i) = beat_width(i) + 1; 
            else
                break;
            end
        end
    end
    % (c) if the width of the blink candidate is too small or longer than 1 second, skip it
    beats_ind = find(beat_width > minimum_blink_range & beat_width < samplingrate);

    for i = 1:length(beats_ind)
        [val pos] =  max(signal(beat_begins(beats_ind(i)):beat_begins(beats_ind(i))+beat_width(beats_ind(i))));
        peaks(i) = beat_begins(beats_ind(i)) + pos - 1; 
    end
    
    %% (2) Approximate every blink range with a polynomial function, and check that 
    % the function is concave 
%     figure, plot(plot_range / samplingrate,signal(plot_range)), hold on;
    sel_peaks = beat_begins;
    sel_peaks = [];
    for i = 1:length(peaks)
        Y = signal(beat_begins(beats_ind(i)) : beat_begins(beats_ind(i)) + beat_width(beats_ind(i)));
        X = (1:length(Y)) - 1;
        P = polyfit(X,Y,3);
        Y_approx = P(1)*X.*X.*X + P(2)*X.*X + P(3)*X + P(4);
        [max_val max_pos] = max(Y_approx);
        [min_val min_pos] = min(Y_approx);
        
        if((Y_approx(1) < max_val && Y_approx(end) < max_val) && ...
               (atan2((max_val - Y_approx(1)),   (max_pos/samplingrate)) * 180/pi) > 80 && ...
               (atan2((max_val - Y_approx(end)), (max_pos - X(end))/samplingrate) * 180/pi < 100) &&...
               sum(sqrt(diff(Y_approx).^2 + 1/length(Y_approx))) > length_threshold  &&... 
               min_val == min(Y_approx(1), Y_approx(end)))
            sel_peaks(length(sel_peaks) + 1) = beat_begins(beats_ind(i)) + max_pos;
            blink_range = X + beat_begins(beats_ind(i));
%               if(plot_range(1) < blink_range(1) && blink_range(end) < plot_range(end)) % Just for plotting
%                   plot(blink_range/samplingrate, Y_approx, 'k:', 'LineWidth', 2);
%                   plot(blink_range(1)/samplingrate, Y_approx(1), 'ro', 'MarkerSize', 5);
%                   plot(blink_range(end)/samplingrate, Y_approx(end), 'ro', 'MarkerSize', 5);
%                   plot((blink_range(1) + max_pos)/samplingrate, max_val, 'ro', 'MarkerSize', 5);
%               end
        end
    end
    
   ibli = diff(sel_peaks)/samplingrate; 
   maxtab = [sel_peaks; signal(sel_peaks)]';
   
end