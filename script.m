%load up fp1-fp3 and fp2-fp4 EEG for no music patients
load('./Data/fp1_fp3_iq.mat');;
load('./Data/fp1_fp3_memory.mat');
load('./Data/fp1_fp3_rest1.mat')
load('./Data/fp1_fp3_rest2.mat');

load('./Data/fp2_fp4_iq.mat');
load('./Data/fp2_fp4_memory.mat');
load('./Data/fp2_fp4_rest1.mat');
load('./Data/fp2_fp4_rest2.mat');
labels = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 32]; %subjects IDs

% fp2_fp4_memory(2,1:150000) = 0;
% fp1_fp3_memory(2,1:150000) = 0;
% path = '/Users/artemlenskiy/Documents/Research/Data/EEG/Synchronized and segmented/eeg no music/';
% counter = 0;
% labels = 0;
% for i = 1:40
%     i
%     file_resting_1 = [path num2str(i) '-1.txt'];
%     file_resting_2 = [path num2str(i) '-3.txt'];
%     file_iq = [path num2str(i) '-2.txt'];
%     file_memory = [path num2str(i) '-4.txt'];
%     if exist(file_resting_1, 'file')
%         counter = counter + 1;        
%         temp_resting_1 = importdata(file_resting_1, ' ', 0);
%         temp_resting_2 = importdata(file_resting_2, ' ', 0);
%         temp_iq = importdata(file_iq, ' ', 0);
%         temp_memory = importdata(file_memory, ' ', 0);
%         labels(counter) = i;
%     end
%     fp2_fp4_rest1(counter, :) = temp_resting_1(:,9);
%     fp1_fp3_rest1(counter, :) = temp_resting_1(:,13);
%     fp2_fp4_rest2(counter, :) = temp_resting_2(:,9);
%     fp1_fp3_rest2(counter, :) = temp_resting_2(:,13);
%     fp2_fp4_iq(counter, :) = temp_iq(:,9);
%     fp1_fp3_iq(counter, :) = temp_iq(:,13);
%     fp2_fp4_memory(counter, 1:length(temp_memory(:,9))) = temp_memory(:,9);
%     fp1_fp3_memory(counter, 1:length(temp_memory(:,13))) = temp_memory(:,13);    
% end
%manually remove artifacts
%replace original signals with manually cleaned up ones
% fp2_fp4_memory(18, 143676) = fp2_fp4_memory(18, 143677);
% fp2_fp4_memory(17, 123400:125600) = 10*rand(125600 - 123400 + 1, 1);
% fp2_fp4_memory(15, 72500:76500) = 50*rand(76500 - 72500 + 1, 1);
% fp2_fp4_memory(15, 119500:121500) = 50*rand(121500 - 119500 + 1, 1);
% fp2_fp4_memory(14, 54600:54900) = 10*rand(54900 - 54600 + 1, 1);
% fp2_fp4_memory(9, 121000:123000) = 50*rand(123000 - 121000 + 1, 1);
% fp2_fp4_memory(9, 138000:139000) = 50*rand(139000 - 138000 + 1, 1);
% fp2_fp4_memory(9, 30200:30800) = 50*rand(30800 - 30200 + 1, 1);
% fp2_fp4_memory(9, 139500:141500) = 50*rand(141500 - 139500 + 1, 1);
% fp2_fp4_memory(2,20500:20700) = 10*rand(20700 - 20500 + 1, 1);
% fp2_fp4_memory(2,20500:20700) = 10*rand(20700 - 20500 + 1, 1);
% fp2_fp4_memory(2,139940) = fp2_fp4_memory(2,139941); %because of NaN
% fp2_fp4_memory(2,140000:150000) = fp2_fp4_memory(2,130000:140000);
% fp2_fp4_memory(1,139445) = fp2_fp4_memory(1,139446); %because of NaN
% fp2_fp4_memory(1,140000:150000) = fp2_fp4_memory(1,130000:140000);
% fp2_fp4_iq(2,77600:79400) = 10*rand(79400 - 77600 + 1, 1);
% fp2_fp4_iq(5,47750:48000) = 10*rand(48000 - 47750 + 1, 1);



%good signals
%good_ind = [1 2 5 7 8 9 12 13 14 15 16 17 18]; %add 7 8 
good_ind = [2 5 12 13 14 16 17 18]; %add 15 7 8 
clear rest1 rest2 iq_test memory_test
%only one eye is analyzed below

for i = 1:18
    session_raw_fp1_fp3{1}(i,:) = fp1_fp3_rest1(i,:);
    session_raw_fp1_fp3{2}(i,:) = fp1_fp3_iq(i,:);
    session_raw_fp1_fp3{3}(i,:) = fp1_fp3_rest2(i,:);
    session_raw_fp1_fp3{4}(i,:) = fp1_fp3_memory(i,1:75000);
    session_raw_fp1_fp3{5}(i,:) = fp1_fp3_memory(i,75001:end);
    session_raw_fp2_fp4{1}(i,:) = fp2_fp4_rest1(i,:);
    session_raw_fp2_fp4{2}(i,:) = fp2_fp4_iq(i,:);
    session_raw_fp2_fp4{3}(i,:) = fp2_fp4_rest2(i,:);
    session_raw_fp2_fp4{4}(i,:) = fp2_fp4_memory(i,1:75000);
    session_raw_fp2_fp4{5}(i,:) = fp2_fp4_memory(i,75001:end);    
end
    
for k = 1:5
    k
    for i = 1:18
        norm_input_signals = [];
        inputs = [session_raw_fp1_fp3{k}(i,:); session_raw_fp2_fp4{k}(i,:)];
        if ~isempty(find(isnan(inputs(1,:))))
            inputs(1, find(isnan(inputs(1,:)))) = 0;
        end
        if ~isempty(find(isnan(inputs(2,:))))
            inputs(2, find(isnan(inputs(2,:)))) = 0;
        end    

        for j = 1:size(inputs,1)
            norm_input_signals = [norm_input_signals; normailizeAndFilterEEG(inputs(j,:))];
        end   
        
        [result, W, A] = ica(norm_input_signals', 'skew');
        %plotArrayOfTS(result', 'ICA');
        if ~isempty(find(abs(result(:, 1)) > 7))
            result(find(abs(result(:, 1)) > 7), 1) = 0;
        end
        if ~isempty(find(abs(result(:, 2)) > 7))
            result(find(abs(result(:, 2)) > 7), 2) = 0;
        end
        if(sum(abs(result(:, 2)) > 3) < sum(abs(result(:, 1)) > 3))
            session{k}(i, :) = result(:,1);
        else
            session{k}(i, :) = result(:,2);
        end
    end
end
%figure, plot(session_raw_fp1_fp3{4}(5,:))
for k = 1:5
    k
    for i = 1:18  
        %[ibli_right, maxtab_right, mintab_right] = extract_ibli(fp1_fp3_rest1(i,:));
        [ibli, maxtab] = extract_ibli(session{k}(i,:));
        session_ibi{k}{i} = ibli;
%         [ibli, maxtab] = extract_ibli(fp2_fp4_rest2(good_ind(i),:));
%         rest2{i} = ibli;
%         [ibli, maxtab] = extract_ibli(fp2_fp4_iq(good_ind(i),:));
%         iq_test{i} = ibli;
%         [ibli, maxtab] = extract_ibli(fp2_fp4_memory(good_ind(i),:));
%         memory_test{i} = ibli;    
    end
end


% for i = 1:length(good_ind)
%     figure(i), hold on;
%     title(['Number: ' num2str(good_ind(i))]);
%     plot((1:length(session{2}(4, :)))/250,session{2}(4, :));
%     %plot(fp1_fp3_iq(good_ind(i),:), 'k');
%     [ibli, maxtab] = extract_ibli(session{2}(4, :));
%     plot(maxtab(:,1)/250, maxtab(:,2),'ro', 'markersize', 5);
%     %[ibli, maxtab, mintab] = extract_ibli(fp1_fp3_iq(good_ind(i),:));
%     %plot(maxtab(:,1), maxtab(:,2),'y.');    
% end

%calcualte number of blinks for each patient during each of four stages
clear rest1_len rest2_len  iq_test_len memory_test_len 
for k = 1:5
    for i = 1:length(good_ind);
        session_ibi_len(k,i) = length(session_ibi{k}{i});
    end
end

%select only those that have more than 100 blinks, others assumed to be
%corrupted
ind_rest1 = find(100 < rest1_len);
ind_rest2 = find(100 < rest2_len);
ind_iq_test = find(100 < iq_test_len);
ind_memory_test= find(100 < memory_test_len);

drop_patients = [];
selected_id = intersect(ind_rest1, intersect(ind_rest2, intersect(ind_iq_test, ind_memory_test)))
drop_patients = find (labels == 1 | labels == 3 | labels == 9); % these patients had disconnted electrodes
final_ind = setdiff(selected_id, drop_patients);

final_ind = 1:length(good_ind);
%sum up all interblink intervals and compare with the test time, both times
%shoud be equal, unless blinks were incorrectly detected
for i = 1:length(final_ind)
    incorrectly_detected_rest1(i) = 300 - sum(rest1{final_ind(i)});
    incorrectly_detected_rest2(i) = 300 - sum(rest2{final_ind(i)});
    incorrectly_detected_iq(i) = 600 - sum(iq_test{final_ind(i)});
    incorrectly_detected_memory(i) = 600 - sum(memory_test{final_ind(i)});
end

good_ind = setdiff(1:18, [3, 6, 8, 9, 10]); 
figure(11), hold on;
set(gca, 'YTick', []);
axis([0 max(max(session_ibi_len)) + 30 0 130]);
title('Inter-blink interval dynamics extracted while 1st time resting stage')
figure(12), hold on;
set(gca, 'YTick', []);
axis([0 max(max(session_ibi_len)) + 30 0 130]);
title('Inter-blink interval dynamics extracted while 2nd time resting stage')
figure(13), hold on;
set(gca, 'YTick', []);
axis([0 max(max(session_ibi_len)) + 30 0 130]);
title('Inter-blink interval dynamics extracted while IQ testing')
figure(14), hold on;
set(gca, 'YTick', []);
axis([0 max(max(session_ibi_len)) + 30 0 130]);
title('Inter-blink interval dynamics extracted while reading the passage')
figure(15), hold on;
set(gca, 'YTick', []);
axis([0 max(max(session_ibi_len)) + 30 0 130]);
title('Inter-blink interval dynamics extracted while memory testing')
plot_step = 7;

for i = 1:length(good_ind);
	color = [rand rand rand];
    for k = 1:5
        figure(10 + k), line([0 max(max(session_ibi_len))],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
        figure(10 + k), plot(session_ibi{k}{good_ind(i)} + (i-1)*plot_step, 'color', color);
        figure(10 + k), text(- 25, (i-1)*plot_step + 2, num2str(good_ind(i)), 'color', color);
    %     figure(11), line([0 max(iq_test_len)],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
    %     figure(11), plot(rest2{final_ind(i)} + (i-1)*plot_step, 'color', color);
    %     figure(11), text(- 25, (i-1)*plot_step + 2, num2str(good_ind(i)), 'color', color);
    %     figure(12), line([0 max(iq_test_len)],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
    %     figure(12), plot(iq_test{final_ind(i)} + (i-1)*plot_step, 'color', color);
    %     figure(12), text(- 25, (i-1)*plot_step + 2, num2str(good_ind(i)), 'color', color);
    %     figure(13), line([0 max(iq_test_len)],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
    %     figure(13), plot(memory_test{final_ind(i)} + (i-1)*plot_step, 'color', color);
    %     figure(13), text(- 25, (i-1)*plot_step + 2, num2str(good_ind(i)), 'color', color);
    end
end

%statistics for number of blinks
%[mean(rest1_len(final_ind)) std(rest1_len(final_ind))]
%[mean(rest2_len(final_ind)) std(rest2_len(final_ind))]
[mean([rest1_len(final_ind) rest2_len(final_ind)]) std([rest1_len(final_ind)  rest2_len(final_ind)])]
[mean(iq_test_len(final_ind)) std(iq_test_len(final_ind))]
[mean(memory_test_len(final_ind)) std(memory_test_len(final_ind))]

%statistics for IBI
clear session_ibi_stat
for k = 1:5
    for i = 1:length(good_ind)
        session_ibi_stat(i,:,k) = [mean(session_ibi{k}{good_ind(i)}) std(session_ibi{k}{good_ind(i)})];
    end
end
% figure, hold on;
% plot(rest12_ibi_stat(:,1), ones(1,length(final_ind)), 'go');
% plot(iq_ibi_stat(:,1), ones(1,length(final_ind)), 'bx');
% plot(memory_ibi_stat(:,1), ones(1,length(final_ind)), 'r.');


figure, hold on;
plot(good_ind, session_ibi_stat(:,1,1), 'go');
plot(good_ind, session_ibi_stat(:,1,2), 'bx');
plot(good_ind, session_ibi_stat(:,1,3), 'g.');
plot(good_ind, session_ibi_stat(:,1,4), 'rd');
plot(good_ind, session_ibi_stat(:,1,5), 'md');

%plot(rest1_ibi_stat(:,1), 'k.');
% errorbar(rest12_ibi_stat(:,1), sqrt(rest12_ibi_stat(:,2)), 'go');
% errorbar(iq_ibi_stat(:,1),  sqrt(iq_ibi_stat(:,2)), 'bx');
% errorbar(memory_ibi_stat(:,1), sqrt(memory_ibi_stat(:,2)), 'rd');



L = round(2.^[3:0.25:5.5]);
%L = L(1:10);
Q = [-5:1:5];
for i = 1:length(final_ind)
    [alfa mfs] = estimateGFD(rest1{final_ind(i)}', L, Q);
    rest1_alfas(i,:) = alfa;
    [alfa  mfs] = estimateGFD(rest2{final_ind(i)}', L, Q);
    rest2_alfas(i,:) = alfa;
    [alfa  mfs] = estimateGFD(iq_test{final_ind(i)}', L, Q);
    iq_test_alfas(i,:) = alfa;
    [alfa  mfs] = estimateGFD(memory_test{final_ind(i)}', L, Q);
    memory_tes_alfas(i,:) = alfa;    
end


figure, hold on, grid on;
xlabel('\alpha(-)')
ylabel('\alpha(0)')
zlabel('\alpha(+)')
%plot3(rest1_alfas(:,1), rest1_alfas(:,6), rest1_alfas(:,11), '.r');
plot3(rest2_alfas(:,1), rest2_alfas(:,6), rest2_alfas(:,11), 'm.');
plot3(iq_test_alfas(:,1), iq_test_alfas(:,6), iq_test_alfas(:,11), 'g.');
plot3(memory_tes_alfas(:,1), memory_tes_alfas(:,6), memory_tes_alfas(:,11), 'b.');
for i = 1:length(final_ind)
%    text(rest1_alfas(i,1), rest1_alfas(i,6), rest1_alfas(i,11), num2str(final_ind(i)), 'color', 'r');
    text(rest2_alfas(i,1), rest2_alfas(i,6), rest2_alfas(i,11), num2str(labels(final_ind(i))), 'color', 'm');
    text(iq_test_alfas(i,1), iq_test_alfas(i,6), iq_test_alfas(i,11), num2str(labels(final_ind(i))), 'color', 'g');
    text(memory_tes_alfas(i,1), memory_tes_alfas(i,6), memory_tes_alfas(i,11), num2str(labels(final_ind(i))), 'color', 'b');
end

figure, hold on, grid on;
for i = 1:length(final_ind)
    color1 = [1 0 rand];
    color2 = [rand 1 0];
    plot(Q,iq_test_alfas(i, :), 'Color', color1);
    text(Q(2), iq_test_alfas(i,1), num2str(labels(final_ind(i))), 'Color', color1);
    plot(Q,memory_tes_alfas(i, :), 'Color', color2);
    text(Q(2), memory_tes_alfas(i,1), num2str(labels(final_ind(i))), 'Color', color2);
end

