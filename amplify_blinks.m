function frontal_component = amplify_blinks(left_eeg, right_eeg, sampling_rate)
        norm_input_signals = [];
        inputs = [left_eeg; right_eeg];
        %plotArrayOfTS(inputs, 'Original signals','time(s)', 'electorde pairs', 250);
        if ~isempty(find(isnan(inputs(1,:))))
            inputs(1, find(isnan(inputs(1,:)))) = 0;
        end
        if ~isempty(find(isnan(inputs(2,:))))
            inputs(2, find(isnan(inputs(2,:)))) = 0;
        end    
        
        for j = 1:size(inputs,1)
            norm_input_signals = [norm_input_signals; normailizeAndFilterEEG(inputs(j,:),0.16, 0.24, sampling_rate)];
        end
        
        std5 = 5 * std(norm_input_signals(1,:));
        norm_input_signals(1, find(norm_input_signals(1,:) > std5)) = std5; 
        std5 = 5 * std(norm_input_signals(2,:));
        norm_input_signals(2, find(norm_input_signals(2,:) > std5)) = std5;
        
        %frontal_component = norm_input_signals(1,:);
         %plotArrayOfTS(norm_input_signals, 'Normalized signals','time(s)', 'electorde pairs', 250);
         [result, W, A] = ica(norm_input_signals', 'kurt2');
         %plotArrayOfTS(result', 'Independent components','time(s)', 'components', 250);

        pos_ind1 = find(result(:, 1) > 0);
        neg_ind1 = find(result(:, 1) < 0);
        if( std(result(pos_ind1, 1)) < std(result(neg_ind1, 1)))
            result(:, 1) = -result(:, 1);
        end
        
        pos_ind2 = find(result(:, 2) > 0);
        neg_ind2 = find(result(:, 2) < 0);
        if( std(result(pos_ind2, 2)) < std(result(neg_ind2, 2)))
            result(:, 2) = -result(:, 2);
        end
        
        std_m = max(std(abs(result(pos_ind1, 1))), std(abs(result(pos_ind2, 2))));
        s1 = sign(result(pos_ind1,1) - 3*std_m);
        s1(result(:,1) == 0) = 1;
        s2 = sign(result(pos_ind2,2) - 3*std_m);
        s2(result(:,2)==0) = 1;
        %compare number of crossings at std_m for each component 
        if(length(find(diff(s1) ~= 0))  > length(find(diff(s2) ~= 0)))
            frontal_component = result(:,1);
        else
            frontal_component = result(:,2);
        end

end