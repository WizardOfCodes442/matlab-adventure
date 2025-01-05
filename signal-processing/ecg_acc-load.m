function [ecg_signal, scg_signal, bcg_signal, Fs] = load_signals()
    % Load ECG, SCG, and BCG signals
    ecg = load('ecg_data.mat'); % Replace with your file
    scg = load('scg_data.mat'); % Replace with your file
    bcg = load('bcg_data.mat'); % Replace with your file

    % Extract data
    ecg_signal = ecg.ecg;
    scg_signal = scg.scg;
    bcg_signal = bcg.bcg;

    % Sampling frequency (update based on your data)
    Fs = 1000; % Example: 1000 Hz
end
