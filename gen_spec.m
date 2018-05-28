% disp('running gen_spec')
function gen_spec
% % GEN_SPEC: Generates spec file
% %
% % See documentation about processors in https://github.com/flatironinstitute/mountainlab-js/
%
curpath=fileparts(mfilename('fullpath'));
addpath([curpath,'/common/jsonlab']);

processors = {};

exe_command=[fullfile(curpath,'run_mfile.sh') ' "cd(''processors''), histogram_metrics(''$timeseries$'',''$firings$'',''$metrics_out$'')"'];
processors{end+1} = struct('name','kepecs.histogram_metrics','version','0.22','description','Completeness of amplitude histogram. Whitened timeseries recommended.',...
'inputs',{{struct('name','timeseries'),struct('name','firings')}},...
'outputs',{{struct('name','metrics_out')}},...
'parameters',{{}},'opts',{struct('force_run', false)},'exe_command',exe_command);

spec = struct('processors',{processors});

disp(savejson('',spec))
