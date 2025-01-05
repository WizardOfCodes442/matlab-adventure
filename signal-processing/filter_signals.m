function [filtered_ecg, filtered_scg, filtered_bcg] = filter_signals(ecg_signal, scg_signal, bcg_signal, Fs)
    % Bandpass filter design (e.g., 0.5-50 Hz for ECG)
    low_cutoff = 0.5; % Hz
    high_cutoff = 50; % Hz
    [b, a] = butter(4, [low_cutoff high_cutoff] / (Fs/2), 'bandpass');

    % Apply the filter
    filtered_ecg = filtfilt(b, a, ecg_signal);
    filtered_scg = filtfilt(b, a, scg_signal);
    filtered_bcg = filtfilt(b, a, bcg_signal);
end
