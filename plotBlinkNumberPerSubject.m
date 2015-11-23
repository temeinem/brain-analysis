function plotBlinkNumberPerSubject(session_ibi_len, good_ind)
    colors = get(gca,'colororder');close;
    colors = [colors; colors; colors; colors];
	markers = {'+','o','*','.','x'};
    %plot blink numbers for each "good" subject for every session
    labels = {'Resting stage 1','IQ test', 'Resting stage 2', 'Reading passage', 'Memory test'};
    pair{1} = [1 3]; % resting stage 1 and stage 2 
    pair{2} = [4 5]; % reading and comprehension test 
    pair{3} = [2 4]; % IQ and reading
    pair{4} = [2 5]; % IQ and memory testing 
    pair{5} = [1 3 2]; % resting 1 and 2 and IQ test
    pair{6} = [1 3 4]; % resting 1 and 2 and Reading
    
    for j = 1:size(pair,2)
        figure('Position', [100, 100, 540, 257]), hold on; title('Relationship between number blinks and a task');
        xlabel('Subject number'); ylabel('Number of blinks');
        for k = 1:size(pair{j}(:),1)
            plot(good_ind, session_ibi_len(pair{j}(k), good_ind),'LineStyle',':','Marker', markers{pair{j}(k)}, 'LineWidth', 2, 'MarkerSize',5, 'color', colors(pair{j}(k),:));
        end
        
        if size(pair{j}, 2) == 2
            legend(gca, labels{pair{j}(1)} ,labels{pair{j}(2)});
        end
        if size(pair{j}, 2)== 3
            legend(gca, labels{pair{j}(1)}, labels{pair{j}(2)}, labels{pair{j}(3)});
        end        
    end
end