function waveform_features(timeseries_filt_fname,firings_fname,path_out,clip_size)

mfilepath=fileparts(mfilename('fullpath'));
addpath([mfilepath,'/waveform_features']);


fprintf('Running kepecs.waveform_features...\n');
waveform_features_f(timeseries_filt_fname,firings_fname,path_out,clip_size)

