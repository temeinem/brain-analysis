load('./Data/fp1_fp3_iq.mat');;
load('./Data/fp1_fp3_memory.mat');
load('./Data/fp1_fp3_rest1.mat')
load('./Data/fp1_fp3_rest2.mat');

load('./Data/fp2_fp4_iq.mat');
load('./Data/fp2_fp4_memory.mat');
load('./Data/fp2_fp4_rest1.mat');
load('./Data/fp2_fp4_rest2.mat');
labels = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 19, 32]; %subjects IDs
good_ind = [2 5 12 13 14 16 17 18];

test = [fp2_fp4_rest1(good_ind(i),:); fp1_fp3_rest1(good_ind(i),:)];
input_signals = [];

for i = 1:size(test,1)
    input_signals = [input_signals; (test(i,:) - mean(test(i,:)))/std(test(i,:))];
end

plotArrayOfTS(input_signals, 'Normalized');

rb = input_signals(1,:) + input_signals(2,:);
figure, plot(rb)

[Xw WhiteT Xc V D] = decorrelate(input_signals');

projectSignals = V * input_signals;
projectSignals(1,:) = 0;
F = D;
F(1, 1) = 0.001;
Reconstructed =  inv( V*diag(diag(F).^-0.5)*V') * Xw;
plotArrayOfTS(input_signals, 'Original');
% plotArrayOfTS(Xw, 'Decorrelated');
plotArrayOfTS(Reconstructed, 'Reconstructed');

[icasig, W, A] = ica(input_signals', 'cosh');

plotArrayOfTS(icasig', 'ICA');