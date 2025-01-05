% Main script

% Step 1: Load signals
[ecg_signal, scg_signal, bcg_signal, Fs] = load_signals();

% Step 2: Filter signals
[filtered_ecg, filtered_scg, filtered_bcg] = filter_signals(ecg_signal, scg_signal, bcg_signal, Fs);

% Step 3: Detect R-peaks and calculate heart rate
[r_peaks, heart_rate] = detect_r_peaks(filtered_ecg, Fs);

% Step 4: Plot results
t = (0:length(filtered_ecg)-1) / Fs;

figure;
subplot(3,1,1);
plot(t, filtered_ecg);
title('Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

hold on;
plot(r_peaks/Fs, filtered_ecg(r_peaks), 'ro');
legend('ECG', 'R-Peaks');
hold off;

subplot(3,1,2);
plot(t, filtered_scg);
title('Filtered SCG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, filtered_bcg);
title('Filtered BCG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Display Heart Rate
disp(['Average Heart Rate: ' num2str(mean(heart_rate)) ' BPM']);
