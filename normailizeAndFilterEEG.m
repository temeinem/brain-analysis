function filtered_signal = normailizeAndFilterEEG(signal, lpcf, hpcf, samplingrate)
 % normalize
% 	%% ( 1, a ) Remove high frequencies
% 	fresult=fft(signal);
% 	fresult(round(signal_length/samplingrate) +  hpcf * samplingrate:...
%         end - round(signal_length/(hpcf * samplingrate)) - hpcf * samplingrate) = 0;
% 	%% ( 1, b ) Remove low frequencies
% 	fresult(1: lpcf*samplingrate) = 0;
% 	fresult(end - lpcf*samplingrate + 1: end) = 0;
% 	filtered_signal = real(ifft(fresult));
    b = fir1(64,hpcf, 'low');
    filtered_signal = filtfilt(b,1,signal);
    b = fir1(64,lpcf,'high');
    filtered_signal = filtfilt(b,1,filtered_signal);
    %figure, hold on; plot(signal), plot(filtered_signal)
 	filtered_signal = (filtered_signal - mean(filtered_signal))/std(filtered_signal);
    num_bins = 500;
    mn = min(filtered_signal);
    mx = max(filtered_signal);
    
    pmf_est = hist(filtered_signal,[mn:((mx - mn)/num_bins):mx]);
    pmf_est = pmf_est/sum(pmf_est);
    cmf_est = cumsum(pmf_est);
    q1 = find((cmf_est < 0.02) ~= 0);
    min_ampl = mn + (mx - mn) * q1(end) / num_bins;
    q2 = find((cmf_est < 0.99) ~= 0);
    max_ampl = mn + (mx - mn) * q2(end) / num_bins;
    filtered_signal(find(min_ampl > filtered_signal)) = min_ampl;
    filtered_signal(find(max_ampl < filtered_signal)) = max_ampl;    
end