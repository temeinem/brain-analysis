colors = get(gca,'colororder');close;
colors = [colors; colors; colors; colors];
%load up fp1-fp3 and fp2-fp4 EEG for all patients w/o and w/ music
%subjects 1 ~ 18 are w/o music
load('./Data/fp1_fp3_iq_all.mat');;
load('./Data/fp1_fp3_memory_all.mat');
load('./Data/fp1_fp3_rest1_all.mat')
load('./Data/fp1_fp3_rest2_all.mat');

load('./Data/fp2_fp4_iq_all.mat');
load('./Data/fp2_fp4_memory_all.mat');
load('./Data/fp2_fp4_rest1_all.mat');
load('./Data/fp2_fp4_rest2_all.mat');

%labels_nomusic = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 32]; %subjects IDs
sampling_rate = 250;

path = '/Users/artemlenskiy/Documents/Research/Data/EEG/Synchronized and segmented/eeg all/';
[session_raw_fp1_fp3 session_raw_fp2_fp4] = readSplitFrontElectrodes(path);

%manually remove artifacts
%replace original signals with manually cleaned up ones
session_raw_fp2_fp4{1}(21,6900:7650) = 10*rand(7650 - 6900 + 1, 1) - 100;
session_raw_fp2_fp4{1}(19,12000:14000) = 10*rand(14000 - 12000 + 1, 1);
session_raw_fp2_fp4{1}(19,46240:46340) = 10*rand(46340 - 46240 + 1, 1);
session_raw_fp2_fp4{1}(22,74000:74380) = 10*rand(74380 - 74000 + 1, 1);
session_raw_fp2_fp4{2}(19,74400:74650) = 10*rand(74650 - 74400 + 1, 1);
session_raw_fp2_fp4{2}(19,2000:2800) = 10*rand(2800 - 2000 + 1, 1);
session_raw_fp2_fp4{2}(2,77600:79400) = 10*rand(79400 - 77600 + 1, 1);
session_raw_fp2_fp4{2}(5,47750:48000) = 10*rand(48000 - 47750 + 1, 1);
session_raw_fp2_fp4{2}(6,20300:20450) = 10*rand(20450 - 20300 + 1, 1);
session_raw_fp2_fp4{2}(26,56950:57100) = 10*rand(57100 - 56950 + 1, 1);
session_raw_fp2_fp4{3}(26,5600:5900) = 10*rand(5900 - 5600 + 1, 1);
session_raw_fp2_fp4{3}(26,21330:21480) = 10*rand(21480 - 21330 + 1, 1);
session_raw_fp2_fp4{3}(26,16350:16450) = 10*rand(16450 - 16350 + 1, 1);
session_raw_fp2_fp4{4}(26,50850:51050) = 10*rand(51050 - 50850 + 1, 1);
session_raw_fp2_fp4{5}(26,41660:42150) = 10*rand(42150 - 41660 + 1, 1);
session_raw_fp2_fp4{3}(28,20600:22300) = 10*rand(22300 - 20600 + 1, 1);
session_raw_fp2_fp4{1}(28,42525:43000) = 10*rand(43000 - 42525 + 1, 1);
session_raw_fp2_fp4{1}(28,25300:25900) =  10*rand(25900 - 25300 + 1, 1);
session_raw_fp2_fp4{3}(28,20600:22300) = 10*rand(22300 - 20600 + 1, 1);

session_raw_fp2_fp4{3}(25,67600:69200)  = 10*rand(69200 - 67600 + 1, 1);
session_raw_fp2_fp4{3}(17,55500:56300) = 10*rand(56300 - 55500 + 1, 1);
session_raw_fp2_fp4{3}(17,74650:74800) = 10*rand(74800 - 74650 + 1, 1);
session_raw_fp2_fp4{3}(1,28550:28700) = 10*rand(28700 - 28550 + 1, 1);
session_raw_fp2_fp4{3}(21,43400:43550) = 10*rand(43550 - 43400 + 1, 1);
session_raw_fp2_fp4{3}(19,10800:11100) = 10*rand(11100 - 10800 + 1, 1);
session_raw_fp2_fp4{3}(24,74600:75000) = 10*rand(75000 - 74600 + 1, 1);
session_raw_fp2_fp4{3}(24,56400:57000) = 10*rand(57000 - 56400 + 1, 1);
session_raw_fp2_fp4{3}(24,58800:59100) = 10*rand(59100 - 58800 + 1, 1);
session_raw_fp2_fp4{5}(24,9850:10250) = 10*rand(10250 - 9850 + 1, 1);
session_raw_fp2_fp4{1}(25,29600:30300) = 10*rand(30300 - 29600 + 1, 1);
session_raw_fp2_fp4{1}(25,32790:33500) = 10*rand(33500 - 32790 + 1, 1);
session_raw_fp2_fp4{1}(25,60000:61000) = 10*rand(61000 - 60000 + 1, 1);
session_raw_fp2_fp4{2}(25,47600:47750)  = 10*rand(47750 - 47600 + 1, 1);
session_raw_fp2_fp4{3}(25,2980:3100)  = 10*rand(3100 - 2980 + 1, 1);
session_raw_fp2_fp4{3}(25,63050:63450)  = 10*rand(63450 - 63050 + 1, 1);
session_raw_fp2_fp4{3}(25,67600:69200)  = 10*rand(69200 - 67600 + 1, 1);
session_raw_fp2_fp4{3}(25,66460:66560)  = 10*rand(66560 - 66460 + 1, 1);
session_raw_fp2_fp4{4}(25,58350:58700) = 10*rand(58700 - 58350 + 1, 1);
session_raw_fp2_fp4{5}(25,16600:17100) = 10*rand(17100 - 16600 + 1, 1);
session_raw_fp2_fp4{5}(28,68675:75000) = session_raw_fp2_fp4{5}(28,62350:68675);


session_raw_fp2_fp4{4}(22,40140:40220) = 10*rand(40220 - 40140 + 1, 1);
session_raw_fp2_fp4{4}(19,21300:21650) = 10*rand(21650 - 21300 + 1, 1);
session_raw_fp2_fp4{4}(2,20500:20700) = 10*rand(20700 - 20500 + 1, 1);
session_raw_fp2_fp4{4}(2,20500:20700) = 10*rand(20700 - 20500 + 1, 1);
session_raw_fp2_fp4{4}(9, 30200:30800) = 50*rand(30800 - 30200 + 1, 1);
session_raw_fp2_fp4{4}(14, 54600:54900) = 10*rand(54900 - 54600 + 1, 1);
session_raw_fp2_fp4{4}(15, 72500:75000) = 50*rand(75000 - 72500 + 1, 1);
session_raw_fp2_fp4{5}(20, 72500:73300) = 10*rand(73300 - 72500 + 1, 1);
session_raw_fp2_fp4{5}(20, 70400:71600) = 10*rand(71600 - 70400 + 1, 1);

session_raw_fp2_fp4{5}(9, 64500:66500) = 50*rand(66500 - 64500 + 1, 1);
session_raw_fp2_fp4{5}(2,64940) = session_raw_fp2_fp4{5}(2,64941); %because of NaN
session_raw_fp2_fp4{5}(2,65000:end) = session_raw_fp2_fp4{5}(2,55000:65000);
session_raw_fp2_fp4{5}(1,64445) = session_raw_fp2_fp4{5}(1,64446); %because of NaN
session_raw_fp2_fp4{5}(1,65000:end) = session_raw_fp2_fp4{5}(1,55000:65000);
session_raw_fp2_fp4{5}(15, 44500:46500) = 50*rand(46500 - 44500 + 1, 1);
session_raw_fp2_fp4{5}(17, 48400:50600) = cumsum(rand(50600 - 48400 + 1, 1) - 0.5);
session_raw_fp2_fp4{5}(18,40900:41000) = 10*rand(41000 - 40900 + 1, 1);
session_raw_fp2_fp4{5}(18,68671:end) = session_raw_fp2_fp4{5}(18, 62342:68671);
session_raw_fp2_fp4{5}(18, 68676) = session_raw_fp2_fp4{5}(18, 68677);
session_raw_fp2_fp4{5}(9, 46000:48000) = 50*rand(48000 - 46000 + 1, 1);
session_raw_fp2_fp4{5}(9, 63000:64000) = 50*rand(64000 - 63000 + 1, 1);
session_raw_fp2_fp4{5}(21,36940:37750) = 10*rand(37750 - 36940 + 1, 1) - 300;


session_raw_fp1_fp3{1}(4,5000:6200) = 10*rand(6200 - 5000+1, 1);
session_raw_fp1_fp3{1}(4,58000:58350) = 10*rand(58350 - 58000+1, 1);
session_raw_fp1_fp3{1}(4,39600:39900) = 10*rand(39900 - 39600+1, 1);
session_raw_fp1_fp3{1}(4,24200:24400) = 10*rand(24400 - 24200+1, 1);
session_raw_fp1_fp3{1}(1,28550:28700) = 10*rand(28700 - 28550 + 1, 1);
session_raw_fp1_fp3{1}(18,21750:22250) = 10*rand(22250 - 21750 + 1, 1);
session_raw_fp1_fp3{2}(19,74390:74531) = 10*rand(74531 - 74390 + 1, 1);
session_raw_fp1_fp3{2}(19,147100:147450) = 10*rand(147450 - 147100 + 1, 1);
session_raw_fp1_fp3{2}(19,145040:145160) = 10*rand(145160 - 145040 + 1, 1);
session_raw_fp1_fp3{4}(19,21350:21532) = 10*rand(21532 - 21350 + 1, 1);
session_raw_fp1_fp3{5}(19,18380:18520) =  10*rand(18520 - 18380 + 1, 1);
session_raw_fp1_fp3{5}(19,24444:24560)  =  10*rand(24560 - 24444 + 1, 1);

session_raw_fp1_fp3{2}(6,20300:20450) = 10*rand(20450 - 20300 + 1, 1);
session_raw_fp1_fp3{3}(11,73200:73800) = 10*rand(73800 - 73200 + 1, 1);
session_raw_fp1_fp3{3}(19,10800:11400) = 10*rand(11400 - 10800 + 1, 1);
session_raw_fp1_fp3{3}(19,45700:46150) =  10*rand(46150 - 45700 + 1, 1);
session_raw_fp1_fp3{3}(19,37440:37540) =  10*rand(37540 - 37440 + 1, 1);


session_raw_fp1_fp3{4}(4,35100:35900) = 10*rand(35900 - 35100+1, 1);
session_raw_fp1_fp3{4}(4,60200:60700) = 10*rand(60700 - 60200+1, 1);
session_raw_fp1_fp3{4}(11,800:1200) = 0;

session_raw_fp1_fp3{5}(11,41986:42120) = 0;
session_raw_fp1_fp3{5}(11,65230:65870) = 0;
session_raw_fp1_fp3{5}(11,34800:35300) = 0;
session_raw_fp1_fp3{5}(11,60300:61070) = 0;
session_raw_fp1_fp3{5}(11,72750:73695) = 0;
session_raw_fp1_fp3{5}(11,28500:29000) = 0;
session_raw_fp1_fp3{5}(11,46840:47375) = 0;
session_raw_fp1_fp3{5}(11,38144:39000) = 0;
session_raw_fp1_fp3{5}(11,52140:52320) = 0;
session_raw_fp1_fp3{5}(11,42100:42900) = 0;
session_raw_fp1_fp3{5}(1,64441:end) = session_raw_fp2_fp4{5}(1,64441:end);
session_raw_fp1_fp3{5}(2,65000:end) = session_raw_fp1_fp3{5}(2,55000:65000);
session_raw_fp1_fp3{5}(4,23200:23700) = 10*rand(23700 - 23200+1, 1);
session_raw_fp1_fp3{5}(4,32150:32500) = 10*rand(32500 - 32150+1, 1);
session_raw_fp1_fp3{5}(4,44400:44700) = 10*rand(44700 - 44400+1, 1);
session_raw_fp1_fp3{5}(4,49300:49990) = 10*rand(49990 - 49300+1, 1);
session_raw_fp1_fp3{5}(4,54420:54600) = 10*rand(54600 - 54420 +1, 1);
session_raw_fp1_fp3{5}(4,57600:57750) = 10*rand(57750 - 57600+1, 1);
session_raw_fp1_fp3{5}(4,61200:61350) = 10*rand(61350 - 61200+1, 1);
session_raw_fp1_fp3{5}(18,40900:41200) = 10*rand(41200 - 40900 + 1, 1);
session_raw_fp1_fp3{5}(18,68671:end) = session_raw_fp2_fp4{5}(18, 68671:end);
session_raw_fp1_fp3{5}(28,68675:75000) = session_raw_fp1_fp3{5}(28,62350:68675);
session_raw_fp1_fp3{5}(20,70500:73500) = 10*rand(73500 - 70500 + 1, 1);

session_raw_fp1_fp3{5}(26,41400:42105)  = 10*rand(42105 - 41400 + 1, 1);
session_raw_fp1_fp3{5}(21,37000:37420)  = 10*rand(37420 - 37000 + 1, 1);

%% Preprocess EEG by removing low and high frequencies and apply ICA
for k = 1:5
    for i = 1:28
        session{k}(i, :) = amplify_blinks(session_raw_fp1_fp3{k}(i,:), session_raw_fp2_fp4{k}(i,:), 250);
    end
end
% 1,3,9 patients had disconnted electrodes
good_ind = setdiff(1:28, [3, 4, 6, 8, 9, 10, 21, 25, 27]); 
%good_ind = setdiff(19:28, [4, 6, 8, 9, 10]); 
%good_ind = 1:28;

%% Detect blinks and form inter-blink intervals
plot_detected_beats = 0;
for k = 1:5
    k
    for i = 1:length(good_ind)
        [ibli, maxtab] = extract_ibli(session{k}(good_ind(i),:));
         session_ibi{k}{good_ind(i)} = ibli;
         if plot_detected_beats
             figure('Position', [100, 100, 800, 600]), hold on;
             plot((1:length(session{k}(good_ind(i),:)))/250, session{k}(good_ind(i),:)); 
             title(['Session = ' num2str(k) ' Subject = ' num2str(good_ind(i))]);
             plot(maxtab(:,1)/samplingrate, maxtab(:,2), 'ro', 'MarkerSize', 5); 
         end
    end
end


%% Calcualte number of blinks for each patient during each of five stages
for k = 1:5
    for i = 1:size(session_ibi{k},2);
        session_ibi_len(k,i) = length(session_ibi{k}{i});
    end
end
session_ibi_len(2,:) = session_ibi_len(2,:) / 2;
%statistics for number of blinks
[mean(session_ibi_len); std(session_ibi_len)]


%%
%plot blink numbers for each "good" subject for every session
markers = {'+','o','*','.','x'};
figure('Position', [100, 100, 540, 257]), hold on; title('Relationship between number blinks and a task');
xlabel('Subject number'); ylabel('Number of blinks');
for k = 1:5
    plot(1:length(good_ind), session_ibi_len(k, good_ind),'LineStyle',':','Marker',markers{k}, 'LineWidth', 2, 'MarkerSize',5, 'color', colors(k,:));
end
legend(gca, 'Resting stage 1','IQ test', 'Resting stage 2', 'Reading passage', 'Memory test', 'Location', 'Best' );

% Idea select only those that have more than 50 blinks, others assumed to be corrupted
% ind1 = find(session_ibi_len(1,:) > 50);
% ind2 = find(session_ibi_len(2,:) > 50);
% ind3 = find(session_ibi_len(3,:) > 50);
% ind4 = find(session_ibi_len(4,:) > 50);
% ind5 = find(session_ibi_len(5,:) > 50);
% selected = intersect(ind1, intersect(ind2, intersect(ind3, intersect(ind4, ind5))));

%%
% Draw BRV for every session
drawBRVarray(session_ibi, good_ind, session_ibi_len);


%%
%Calcualte mean and standard deviation for BRV
clear session_ibi_stat
for k = 1:5
    for i = 1:length(good_ind)
        session_ibi_stat(i,:,k) = [mean(session_ibi{k}{good_ind(i)}) std(session_ibi{k}{good_ind(i)})];
    end
end

%%
% Plot average IBI 
markers = {'+','o','*','.','x'};
figure('Position', [100, 100, 540, 257]), hold on; title('Average IBI vs task');
xlabel('Subject number'); ylabel('Average inter-blink interval');
for k = 1:5
        plot(1:length(good_ind), session_ibi_stat(:, 1, k),'LineStyle',':','Marker',markers{k}, 'LineWidth', 2, 'MarkerSize',5, 'color', colors(k,:));
        %errorbar(1:length(good_ind), session_ibi_stat(:, 1, k),session_ibi_stat(:, 2, k),'LineStyle',':','Marker',markers{k}, 'LineWidth', 2, 'MarkerSize',5);
end
legend(gca, 'Resting stage 1','IQ test', 'Resting stage 2', 'Reading passage', 'Memory test', 'Location', 'Best' );

%%
% Plot standard deviation IBI 
markers = {'+','o','*','.','x'};
figure('Position', [100, 100, 540, 257]), hold on; title('\sigma(IBI) vs task');
xlabel('Subject number'); ylabel('\sigma(IBI)');
for k = 1:5
        plot(1:length(good_ind), session_ibi_stat(:, 2, k),'LineStyle',':','Marker',markers{k}, 'LineWidth', 2, 'MarkerSize',5, 'color', colors(k,:));
        %errorbar(1:length(good_ind), session_ibi_stat(:, 1, k),session_ibi_stat(:, 2, k),'LineStyle',':','Marker',markers{k}, 'LineWidth', 2, 'MarkerSize',5);
end
legend(gca, 'Resting stage 1','IQ test', 'Resting stage 2', 'Reading passage', 'Memory test', 'Location', 'Best' );


%% Estimate multifractal spectrum for BRV
L = round(2.^[2.5:0.25:5]);
%L = L(1:10);
Q = [-5:1:5];
for k = 1:5
    for i = 1:length(good_ind)
        [alfa mfs] = estimateGFD(session_ibi{k}{good_ind(i)}', L, Q);
        session_alfas{k}(i,:) = alfa;   
    end
end

%% Plot multifractal space
figure, hold on, grid on;
xlabel('\alpha(-)')
ylabel('\alpha(0)')
zlabel('\alpha(+)')
for k = 1:5
    for i = 1:length(good_ind)
    %    text(rest1_alfas(i,1), rest1_alfas(i,6), rest1_alfas(i,11), num2str(final_ind(i)), 'color', 'r');
        plot3(session_alfas{k}(i,1), session_alfas{k}(i,6),session_alfas{k}(i,end), 'Marker', markers{k}, 'color', colors(k, :));
        text(session_alfas{k}(i,1), session_alfas{k}(i,6), session_alfas{k}(i,end), num2str(good_ind(i)), 'color', colors(k, :));
    end
end

figure, hold on, grid on;
for i = 1:length(good_ind)
    color1 = [0.5 0 rand/2 *.5  + 0.5];
    color2 = [rand/2 *.5 + 0.5 0.5 0];
    plot(Q,session_alfas{4}(i,:), 'Color', color1);
    text(Q(1) - 1.25, session_alfas{4}(i,1), num2str(good_ind(i)), 'Color', color1);
    plot(Q,session_alfas{5}(i,:), 'Color', color2);
    text(Q(1) - 0.75, session_alfas{5}(i,1), num2str(good_ind(i)), 'Color', color2);
end

