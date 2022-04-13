function NVCP_MSM_surf(inmesh,refmesh,indata,refdata,output,config,trans)
%% registration between surface using MSM methods (Robinson et.al., 2018 NI) 
% 
%% commnad with trans 
if ~exist('config','var')
    configid = 0;
elseif isempty(config)
    configid = 0;
else
    configid = 1;
end
if ~exist('trans','var')
    transid = 0;
elseif isempty(trans)
    transid = 0;
else
    transid = 1;
end
if configid == 0 && transid == 0
    command =  ['msm --inmesh=',inmesh,' --refmesh=',refmesh,' --indata=',indata,' --refdata=',refdata,' -o ',output];...
    system(command);
elseif configid == 1 && transid == 0
    command =  ['msm --conf=',config,' --inmesh=',inmesh,' --refmesh=',refmesh,' --indata=',indata,' --refdata=',refdata,' -o ',output];...
    system(command);
elseif configid == 0 && transid == 1
    command =  ['msm --trans=',trans,' --inmesh=',inmesh,' --refmesh=',refmesh,' --indata=',indata,' --refdata=',refdata,' -o ',output];...
    system(command);
elseif configid == 1 && transid == 1
    command =  ['msm --trans=',trans,' --conf=',config,' --inmesh',inmesh,' --refmesh=',refmesh,' --indata=',indata,' --refdata=',refdata,' -o ',output];...
    system(command);
end