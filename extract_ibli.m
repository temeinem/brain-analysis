function [ibli maxtab] = extract_ibli(signal)
    samplingrate = 250;
    filtering_constant = 5;
    minimum_blink_range = samplingrate/25;
    plot_range = 52800:53500;
    %figure, hold on, plot(plot_range, signal(plot_range)); title('Original vs filtered');
    %% ( 1 ) Remove high frequencies
    fresult=fft(signal);
    fresult(round(length(fresult)*1/samplingrate) +  filtering_constant * samplingrate:...
        end - round(length(fresult)*1/(filtering_constant * samplingrate)) - filtering_constant * samplingrate)=0;
    lowpass_signal=real(ifft(fresult));
    %plot(plot_range, lowpass_signal(plot_range));
    %% ( 2 ) Set to zero all samples which amptudes are less than standard deviation
    %figure, plot(signal - lowpass_signal)
    %%%%%%%%%%%%%%%%%%%corrected = signal - lowpass_signal;
    corrected = lowpass_signal;
    stand_dev = std(corrected);
    zero_ind = find(corrected < std(corrected));
    corrected(zero_ind) = 0;
    %figure, hold on, plot(plot_range, corrected(plot_range)); title('Samples less than \sigma are removed');
%         temp(find(isnan(temp) == 1)) = 0;
%         fresult=fft(temp);
%         fresult(length(temp)/10 : round(length(fresult))- length(temp)/10)=0;
%         fresult(1: length(temp)/100) = 0;
%         fresult(length(fresult) - length(temp)/100: length(fresult)) = 0;
%         corrected=real(ifft(fresult));
%         %[maxtab, mintab] = peakdet(temp, 6* std(corrected));
    %%  ( 3 )  Detect the beginning and the end of the range of a blink candidate 
    % (3, a) Find the beginning of each beat
    nzi = find(corrected ~= 0);
    nzi_dif = nzi(2:end) - nzi(1:end-1);
    beat_begins = nzi(find(nzi_dif ~= 1) + 1);
    % (3, b)  Find widths of blink range candidates
    beat_width = [];
    for i = 1:length(beat_begins)
        beat_width(i) = 0;
        for j = 1:length(corrected) - i
            if(beat_begins(i) + j > length(corrected)) %refactor
                break;
            end
            if(corrected(beat_begins(i) + j) ~= 0)
                beat_width(i) = beat_width(i) + 1; 
            else
                break;
            end
        end
    end
    % (3, c) if the width of the blink candidate is small, skip it
    beats_ind = find(beat_width > minimum_blink_range);
    for i = 1:length(beats_ind)
        [val pos] =  max(signal(beat_begins(beats_ind(i)):beat_begins(beats_ind(i))+beat_width(beats_ind(i))));
        peaks(i) = beat_begins(beats_ind(i)) + pos - 1; 
    end
    
    %% (4) Approximate every blink range with a polynomial function, and check that 
    % the function is concave 
    %figure, plot(plot_range,signal(plot_range)), hold on;
    sel_peaks = beat_begins;
    sel_peaks = [];
    for i = 1:length(peaks)
        Y = signal(beat_begins(beats_ind(i)):beat_begins(beats_ind(i))+beat_width(beats_ind(i)));
        X = 1:length(Y);
        P = polyfit(X,Y,3);
        Y_ = P(1)*X.*X.*X + P(2)*X.*X + P(3)*X + P(4);
        [max_val m_pos] = max(Y_);
        [min_val min_pos] = min(Y_);
        if((Y_(1) < max_val && Y_(end) < max_val) ) %&& (max_val - (Y_(1) + Y_(end))/2 > samplingrate/25)
            sel_peaks(length(sel_peaks) + 1) = beat_begins(beats_ind(i)) + m_pos;
            blink_range = X + beat_begins(beats_ind(i));
%             if(plot_range(1) < blink_range(1) && blink_range(end) < plot_range(end)) % Just for plotting
%                 plot(blink_range, Y_);
%                 plot(blink_range(1), Y(1), 'ro', 'MarkerSize', 5);
%                 plot(blink_range(end), Y(end), 'ro', 'MarkerSize', 5);
%                 plot(blink_range(1) + m_pos, max_val, 'ro', 'MarkerSize', 5);
%             end
        end
    end
    

   %peaks = peakfinder(corrected, 2.5*std(corrected)); %(max(corrected)-min(corrected))/4

   ibli = diff(sel_peaks)/samplingrate; 
   maxtab = [sel_peaks; signal(sel_peaks)]';
%    plot(maxtab(:,1), maxtab(:,2),'r.');


%         left_eye_eeg(find(isnan(left_eye_eeg) == 1)) = 0;
%         fresult=fft(left_eye_eeg);
%         fresult(length(left_eye_eeg)/30 : round(length(fresult))- length(left_eye_eeg)/30)=0;
%         corrected=real(ifft(fresult));
%         [maxtab_left, mintab_left] = peakdet(2 * std(corrected), 50);
%         
%         right_eye_eeg(find(isnan(right_eye_eeg) == 1)) = 0;
%         fresult=fft(right_eye_eeg);
%         fresult(length(right_eye_eeg)/30 : round(length(fresult))- length(right_eye_eeg)/30)=0;
%         corrected=real(ifft(fresult));
%         [maxtab_right, mintab_right] = peakdet(2 * std(corrected), 50);
%         
%         max_loc = 0;
%         index = 1;
%         for i = 1:min(length(maxtab_right(:,1)), length(maxtab_left(:,1)))
%             if (min(abs(maxtab_right(:,1) - maxtab_left(i,1))) < 5)
%                 max_loc(index) = maxtab_right(i,1);
%                 index = index + 1;
%             end
%         end
%         
%         
%         ibli = diff(max_loc)/250; 
        
%     figure, hold on,
%     plot(eye_eeg, 'g')    
%     plot(corrected, 'b')
%     plot(mintab(:,1), mintab(:,2), 'm.');
%     plot(maxtab(:,1), maxtab(:,2), 'r.');
%     axis([0 length(eye_eeg) min(eye_eeg) - abs(0.05*min(eye_eeg)) max(eye_eeg) + abs(0.05*max(eye_eeg))]);
%     figure, plot(ibli);        
end