function waveform_features_f(timeseries_fname,firings_fname,path_out,clip_size)
% 
% if (nargin<1) timeseries_fname='/home/hoodoo/mountainsort_temp/mountainlab/tmp_long_term/2017-01-25_15-30-44/c64b83b201d8995db0caf3436407c190e50ca3c3-mountainsort.bandpass_filter-timeseries_out.tmp'; end;
% if (nargin<2) firings_fname='/home/hoodoo/mountainsort/P35/2017-01-25_15-30-44/output/ms3--t4/firings.mda'; end;
% if (nargin<3) cluster_metrics_out_fname='/home/hoodoo/mountainsort/P35/2017-01-25_15-30-44/output/ms3--t4/tmp2.json'; end;
% if (nargin<4) clip_size=50; end;

mfilepath=fileparts(mfilename('fullpath'));
addpath([mfilepath,'/../common']);
addpath([mfilepath,'/../common/jsonlab']);

fprintf('Reading...\n');

%X=readmda_block(timeseries_fname,[1,1],[4,32556*60*10]);
X=readmda(timeseries_fname);
FF=readmda(firings_fname);

times=FF(2,:);

fprintf('Extracting clips...\n');
clips=ms_extract_clips2(X,times,clip_size);

fprintf('Computing features...\n');
features=extract_features_from_clips(clips);
%figure; ms_view_clusters(features,labels);

%write clips and features
fprintf('Writing files...\n');
clipfile = fullfile(path_out,'clips.mda');
featurefile = fullfile(path_out,'features.mda');

writemda32(clips,clipfile);
writemda32(features,featurefile);


function features=extract_features_from_clips(clips)
[M,T,L]=size(clips);
normalized_clips=zeros(size(clips));
npca_per_ch=1;
nfeature_per_ch=npca_per_ch+1; % One energy feature + PCA features; 
npca=M*nfeature_per_ch;
features=zeros(npca,L);
for m=1:M
    energy=sum(clips(m,:,:).^2,2)./T;
    energy(energy==0)=0.1;
    energy_norm=ones(T,1)*squeeze(energy)';
    normalized_clips(m,:,:)=squeeze(clips(m,:,:))./energy_norm;
    tmp=ms_event_features(normalized_clips(m,:,:),npca_per_ch);
    features((m-1)*nfeature_per_ch+(1),:)=energy;
    features((m-1)*nfeature_per_ch+(2:(npca_per_ch+1)),:)=tmp;
end;
