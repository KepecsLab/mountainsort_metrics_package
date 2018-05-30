function histogram_metrics(timeseries_fname,firings_fname,cluster_metrics_out_fname)

mfilepath=fileparts(mfilename('fullpath'));
addpath([mfilepath,'/../common']);
addpath([mfilepath,'/../common/jsonlab']);

[path,name] = fileparts(cluster_metrics_out_fname);
cluster_metrics_out_fname_amplitudes = fullfile(path,strcat(name,'.tmp.mda')); 
inputs=struct('timeseries',timeseries_fname,'firings',firings_fname);
outputs=struct('firings_out',cluster_metrics_out_fname_amplitudes);
params=struct();

fprintf('Extracting amplitudes...\n');
ml_run_process('mv.mv_compute_amplitudes',inputs,outputs,params)

fprintf('Reading...\n');
FF=readmda(cluster_metrics_out_fname_amplitudes);
delete(cluster_metrics_out_fname_amplitudes)
amplitudes=FF(4,:);
labels=FF(3,:);

fprintf('Computing metrics...\n');
ids=unique(labels);
[comp1,comp2]=compute_histogram_metrics(amplitudes,labels,ids);

fprintf('Writing output...\n');
OO.clusters=cell(1,length(ids));
for j=1:length(ids)
    A=struct;
    A.label=ids(j);
    A.metrics.completeness1=comp1(j);
    A.metrics.completeness2=comp2(j);
    OO.clusters{j}=A;
end;
savejson('',OO,cluster_metrics_out_fname);

function [comp1,comp2]=compute_histogram_metrics(amplitudes, labels, ids)
comp1 = zeros(1,length(ids));
comp2 = zeros(1,length(ids));
for i = 1:length(ids)
    x = amplitudes(labels==ids(i));
    AvgBin=3; %free param!
    NBin = round((max(x)-min(x)) ./ (2*diff(quantile(x,[0.25,0.75]))/nthroot(length(x),3))) ; %Freedman Diaconis' rule
    if(NBin<=AvgBin)
        comp1(i) = 0;
        comp2(i) = 1;
        continue
    end
    edges=linspace(min(x),max(x),NBin);
    hi=hist(x,edges);
    
     %%method for estimating percentage of missing data
        N_L = mean(hi(1:AvgBin));
        N_R = mean(hi(end-AvgBin+1:end));
        Tail_R_idx  = find(hi>N_L,1,'last');
        if Tail_R_idx < length(hi)
            Tail_L_missing = sum(hi(Tail_R_idx:end))/(sum(hi)+sum(hi(Tail_R_idx:end)));
        else
            Tail_L_missing=0;
        end
        Tail_L_idx  = find(hi>N_R,1,'first');
        if Tail_L_idx > 1
            Tail_R_missing = sum(hi(1:Tail_L_idx))/(sum(hi)+sum(hi(1:Tail_L_idx)));
        else
            Tail_R_missing=0;
        end
    comp1(i) = 1 - sum([Tail_L_missing,Tail_R_missing]);
    
    %%2nd method
        N_L = mean(hi(1:AvgBin));
        N_R = mean(hi(end-AvgBin+1:end));
    mode_x = max(hi); % density at mode
        ratio_l = N_L/mode_x;
        ratio_r = N_R/mode_x;
    comp2(i) = max([ratio_l,ratio_r]);
end

