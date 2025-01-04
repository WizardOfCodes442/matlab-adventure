%% Directory of who is programming 
%%
clearvars
close all
% Corrected base directory
personalDir = 'C:\Users\temit\Music\Animal_Trial';

% Define subpaths using fullfile for correct path construction
saveLoc = fullfile(personalDir, 'Figures');
sICUdatDir = fullfile(personalDir, 'Pig_Lab_Data', 'NewDataCollection', 'Animal_DataCollection', 'MatFiles'); 
paramDir = fullfile(personalDir, 'MATLAB', 'Parameters_setting');

% Add necessary paths
libsPath = fullfile(personalDir, 'MATLAB', 'libs');
matFilesPath = fullfile(personalDir, 'Pig_Lab_Data', 'MatFiles');
% Check if libsPath exists before adding
if exist(libsPath, 'dir')
    addpath(libsPath);
else
    warning('libs directory does not exist: %s', libsPath);
end

% Check if matFilesPath exists before adding
if exist(matFilesPath, 'dir')
    addpath(matFilesPath);
else
    warning('matFiles directory does not exist: %s', matFilesPath);
end
setfonts
%% get the .mat file
olddir= pwd; % select the directory 
cd(sICUdatDir)

%[file,file_path]=uigetfile('*.mat','Select the INPUT DATA FILE(s)');
[file, file_path] = uigetfile(fullfile(sICUdatDir, '*.mat'), 'Select the INPUT DATA FILE(s)');
if isequal(file,0)
    error('No file selected.');
else
    dataStruct = load(fullfile(file_path, file));
end
disp(fieldnames(dataStruct));
load (file);
cd(olddir)
%% Get Patient Info and parameters measured 
file(find(file == '.',1,'last'):end) = []; %remove extension
C = regexp(file, '_', 'split');
f_info= C{6};
%f_info=inputdlg({'Subject Number:'});

subNum=str2double(f_info);
chanName='channelGuideM_ICU_v2.csv';

disp('Size of data:');
disp(size(data));
disp('datastart:');
disp(datastart);
disp('dataend:');
disp(dataend);
disp('channel name:');
disp(chanName);
%% Create a dataset with the data divided by channel for the 2 different format
if exist('data','var')==1  
    [accdata2wind,channels]= get_data(data, datastart, dataend,chanName);
    
end

if exist('data__chan_1_rec_1','var')==1
    [accdata2wind,channels]= get_data_V2(file, chanName,sICUdatDir,olddir); 
end

fs=200; % Sampling frequency 
%% Plot the row data
%f_info=inputdlg({'Save figures? 0 No  1 yes'});
%save_opt=str2double(f_info{1});
save_opt=0;

%%
%% Accelerometer on the Sternum--> Respiration  
%sl_window= slide_window_resp; % sliding window--> lennth in time[s]
sl_window= 30; % sliding window--> lennth in time[s]

if save_opt==1
   cd(saveLoc)
   fig_dir= uigetdir();
   cd(olddir)
else 
    fig_dir=0;
end

%% decide a window in time 60 sec and starting time at 60sec  so from (60 to 120 sec)
start= 10; % the signal start at the second 30
window= 60; % the length of the  signal is 60 sec
accdata = window_accdata(accdata2wind,channels,fs,start,window);
%  accdata_1 = window_accdata(accdata2wind,channels,fs,start,window);
% accdata(1).ECG{1}=accdata_1(1).ECG{18};
% accdata(1).acSX{1}=accdata_1(1).acSX{18};
% accdata(1).acSY{1}=accdata_1(1).acSY{18};
% accdata(1).acSZ{1}=accdata_1(1).acSZ{18};
% accdata(1).acBX{1}=accdata_1(1).acBX{18};
% accdata(1).acBY{1}=accdata_1(1).acBY{18};
% accdata(1).acBZ{1}=accdata_1(1).acBZ{18};
%%
get_plot(accdata, channels,subNum,fs)

%% Respiration
[acSResp_filt,RR]= acS_RespFilt(accdata,channels,fs,subNum,sl_window,save_opt,fig_dir,olddir);

%%  Heart Sound and BCG
[accdata_filt,HR_ECG, lcs_ECG, dist_SCG,ECG_sig_ses,HR_mean,up_sess,lo_sess]= acc_filt(accdata, channels,subNum,fs,save_opt,fig_dir,olddir);
%[accdata_filt,HR_ECG, lcs_ECG, dist_SCG,ECG_sig_ses,HR_mean]= acc_filt_V2(accdata, channels,subNum,fs,save_opt,fig_dir,olddir);

eval( sprintf('HR_ECG_sub_%d =HR_mean(1,:)',subNum));
% VarName=sprintf('HR_ECG_sub_%d',subNum);
% mfilename=sprintf('TEB_RAO_sub_%d.mat', subNum);
% save(mfilename,VarName,'-append');
%% TEB data only on z
[BCG_data_3]= TEB_data(accdata_filt, lcs_ECG, dist_SCG,fs,subNum,save_opt,fig_dir,olddir,up_sess,lo_sess);


%% SNR
[snr_n,snr_i]= SNR_BCG_fun(accdata, channels,subNum,fs);

%% Envelope


%% QAO
%Q_peak_detect;
%% nBCG
%nTEB_struct;
%%
%cd('C:\Users\Asus ZenBook UX430UN\Box Sync\ICU_DataCollection\DataCollection\MATLAB\matFiles')
  filename= sprintf('BCG_data_control_%d',subNum);
  save(filename,'BCG_data_4')