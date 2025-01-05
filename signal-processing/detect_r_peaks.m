function [r_peaks, heart_rate] = detect_r_peaks(filtered_ecg, Fs)
    % Detect R-peaks using findpeaks
    [~, r_peaks] = findpeaks(filtered_ecg, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6*Fs);

    % Calculate Heart Rate (in BPM)
    rr_intervals = diff(r_peaks) / Fs; % Time between peaks (seconds)
    heart_rate = 60 ./ rr_intervals; % Convert to beats per minute
end
