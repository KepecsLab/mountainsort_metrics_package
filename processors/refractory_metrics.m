function refractory_metrics(firings_fname,cluster_metrics_out_fname,samplerate,refractory_period)

mfilepath=fileparts(mfilename('fullpath'));
addpath([mfilepath,'/../common']);
addpath([mfilepath,'/../common/jsonlab']);

fprintf('Reading...\n');
FF=readmda(firings_fname);

times=FF(2,:);
labels=FF(3,:);

fprintf('Computing metrics...\n');
ids=unique(labels);

p_refractory=compute_refractory_metrics(times,labels,ids, samplerate, refractory_period);

fprintf('Writing output...\n');
OO.clusters=cell(1,length(ids));
for j=1:length(ids)
    A=struct;
    A.label=ids(j);
    A.metrics.p_refractory=p_refractory(j);
    OO.clusters{j}=A;
end;
savejson('',OO,cluster_metrics_out_fname);

function p_refractory=compute_refractory_metrics(times, labels, ids, samplerate, refractory_period)
p_refractory = zeros(1,length(ids));
for i = 1:length(ids)
    time=times(labels==ids(i))/samplerate*1000;%in ms
    difft = diff(time);
    p_refractory(i) = sum(difft<refractory_period)/length(time)*100;
end

