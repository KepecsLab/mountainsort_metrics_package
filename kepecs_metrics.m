function kepecs_metrics(timeseries_filt_fname,timeseries_pre_fname,firings_fname,cluster_metrics_out_fname,clip_size,samplerate,refractory_period)

mfilepath=fileparts(mfilename('fullpath'));
addpath([mfilepath,'/mclust_metrics']);
addpath([mfilepath,'/histogram_metrics']);
addpath([mfilepath,'/refractory_metrics']);

fprintf('Running kepecs.mclust_metrics...\n');
mclust_metrics(timeseries_filt_fname,firings_fname,cluster_metrics_out_fname,clip_size)

fprintf('Running kepecs.mclust_metrics...\n');

fprintf('Running kepecs.mclust_metrics...\n');