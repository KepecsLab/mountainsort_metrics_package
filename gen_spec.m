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
processors{end+1} = struct('name','kepecs.histogram_metrics','version','0.23','description','Completeness of amplitude histogram - use same timeseries used for sorting (whitened, usually)',...
'inputs',{{struct('name','timeseries'),struct('name','firings')}},...
'outputs',{{struct('name','metrics_out')}},...
'parameters',{{}},'opts',{struct('force_run', false)},'exe_command',exe_command);

exe_command=[fullfile(curpath,'run_mfile.sh') ' "cd(''processors''), refractory_metrics(''$firings$'',''$metrics_out$'',$samplerate$,$refractory_period$)"'];
processors{end+1} = struct('name','kepecs.refractory_metrics','version','0.13','description','Percentage of firing events within refractory period',...
'inputs',{{struct('name','firings')}},...
'outputs',{{struct('name','metrics_out')}},...
'parameters',{{struct('name','samplerate','optional',0),struct('name','refractory_period','optional',1,'default_value','1.5')}},'opts',{struct('force_run', false)},'exe_command',exe_command);


spec = struct('processors',{processors});

disp(savejson('',spec))
