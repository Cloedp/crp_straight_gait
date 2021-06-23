function r = GetOGLnormGPS(group)

% returns normal GPS values for different child groups based on OGL excel document
%
% ARGUMENTS
% group    ...   name of group for comparison
%
% RETURNS
% r        ...   struct containing normal mean and std GVS and GPS
%
% NOTES
% - in future, storing 'curves' in mat file format would be quicker
%
%
%
% Created May 8th 2013
%
% updated May 10th 2013
% - works on muliple platforms


%--check computer type

if isin(computer,'PCWIN')
    basic = [];
elseif isin(computer,'MACI')
    basic = 'basic';
else
    error([computer,' platform not supported'])
end

%--channel list (in order from excel file)---

ch = {'BelfastPelvisAngles_z','HipAngles_x','KneeAngles_x','AnkleAngles_x',...
    'BelfastPelvisAngles_y','HipAngles_y','KneeAngles_y',...
    'BelfastPelvisAngles_x','HipAngles_z','KneeAngles_z','AnkleAngles_z','FootProgressAngles_z'};


s = filesep;
root = which('ensembler.m');
indx = strfind(root,s);
root = root(1:indx(end-1)) ;
root = [root,'Gait',s,'GPS',s];
gpsfile = [root,'8.20 GPS Calculation.xlsx'];

if ~exist(gpsfile, 'file')
    root = root(1:indx(end-3)) ;
    fl = engine('fld', root, 'search file', '8.20 GPS Calculation.xlsx');
    gpsfile = fl{1};
end

cfile = [root,group,'.mat'];

switch group
    
    case '5-7'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F38:DB49',basic);
        end
        
        mgps = [3.7	4.9	4.8	5.0	5.9	4.0	3.9	2.1	2.5	2.9	2.6	2.8	4.0	4.9	6.0	6.3	5.6	7.2	6.9	4.5	4.6	4.5];
        stdgps = [2.4	2.4	1.9	1.6	1.8	1.5	1.5	0.8	1.1	1.3	1.1	1.3	1.3	2.6	3.1	4.0	2.5	3.4	3.7	0.9	0.9	0.7];
        
    case '8-9'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F51:DB62',basic);
        end
        
        mgps = [3.2	4.8	4.8	4.3	4.3	2.9	3.8	1.4	2.1	2.6	2.7	3.0	3.5	5.5	5.0	5.3	6.7	5.0	5.2	3.8	4.1	3.9];
        stdgps = [2.9	3.8	3.6	1.6	2.1	1.0	2.9	0.6	0.6	1.0	1.5	1.7	1.0	3.1	3.1	3.1	9.6	3.0	4.1	0.9	1.9	1.2];
        
    case'10-12 G'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F64:DB75',basic);
        end
        
        mgps = [5.5	6.2	6.2	4.5	4.1	2.9	2.9	1.3	2.2	1.8	1.8	1.9	2.8	3.8	4.0	5.2	3.7	5.4	4.9	4.0	3.7	3.9];
        stdgps = [-2.4	3.8	3.2	2.4	1.6	0.9	0.8	0.4	0.9	0.7	1.0	0.9	0.8	1.6	2.3	2.9	1.3	2.4	4.1	1.1	1.0	0.9];
        
        
    case '10-12 B'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F77:DB88',basic);
        end
        
        mgps = [3.9	4.4	4.6	4.1	4.0	3.2	3.1	1.6	2.3	2.5	1.9	2.3	3.2	4.1	4.6	5.6	6.9	5.3	4.3	3.7	3.9	3.8];
        stdgps = [1.7	1.8	2.5	1.5	1.6	1.2	1.6	0.8	1.1	1.1	0.8	0.9	0.8	1.7	1.7	2.6	2.9	1.7	2.2	0.5	0.8	0.6];
        
        
    case '13-16 G'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F90:DB101',basic);
        end
        
        mgps = [4.5	5.5	5.4	3.4	3.4	2.7	2.5	1.5	2.1	1.9	2.4	1.6	2.3	5.2	4.9	3.9	4.4	7.1	5.2	3.9	3.5	3.7];
        stdgps = [3.4	4.1	3.4	1.2	1.4	0.9	0.8	0.6	1.2	0.7	1.2	0.8	0.5	1.8	1.5	2.3	1.9	4.1	3.2	1.3	0.9	1.1];
        
    case '13-16 B'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F103:DB114',basic);
        end
        
        mgps = [3.8	5.2	4.9	3.8	3.8	2.6	2.2	1.2	2.5	1.8	2.7	2.9	3.0	4.8	5.2	5.4	4.4	4.8	4.3	3.7	3.4	3.6];
        stdgps = [3.3	3.8	4.0	1.7	1.5	0.9	0.8	0.5	1.1	0.7	1.3	1.5	1.0	2.8	2.9	3.1	3.3	3.2	2.3	1.3	0.8	0.9];
        
        
    case 'Adult F'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F116:DB127',basic);
        end
        
        mgps = [3.6	4.5	5.0	3.9	3.9	3.1	2.7	1.8	2.8	2.4	2.3	2.4	2.4	4.8	5.1	4.1	5.6	4.3	4.3	3.5	3.7	3.6];
        stdgps = [3.2	2.6	3.0	1.5	1.4	1.1	0.8	1.3	1.5	1.5	1.5	1.0	1.4	2.5	2.6	1.8	2.3	2.0	2.5	0.6	0.7	0.6];
        
    case 'Adult M'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F129:DB140',basic);
        end
        
        mgps = [3.1	5.1	4.8	4.2	3.9	2.6	2.6	1.6	2.1	2.4	2.5	2.6	2.5	4.2	5.4	4.5	4.0	3.9	4.4	3.4	3.5	3.4];
        stdgps = [2.2	2.8	2.4	1.8	1.6	1.1	1.1	0.8	0.9	1.0	1.5	2.0	0.9	2.5	2.8	1.9	1.3	2.2	2.1	0.8	0.7	0.6];
        
    case '3-4'
        
        if exist(cfile,'file')==2
            curves = load(cfile,'-mat');
            curves = curves.curves;
        else
            curves=xlsread(gpsfile,'Normal gait variables','F142:DB153',basic);
        end
        mgps = [6.0	6.6	6.3	6.6	7.0	4.9	5.0	2.9	3.8	4.5	3.6	4.7	5.4	7.1	7.8	7.2	8.2	5.6	4.7	5.6	5.8	5.7];
        stdgps = [2.7	2.2	2.7	1.8	2.1	2.4	1.6	1.0	1.8	2.4	1.5	1.6	1.2	2.8	4.0	2.8	3.8	2.7	1.8	0.8	1.7	1.1];
        
        
    otherwise
        
        error('group not identified')
        
end


%--Save mat file for future use---
%
if exist(cfile,'file')~=2
    save(cfile,'curves')
end



r =struct;
for i = 1:length(ch)
    r.(ch{i}).line = curves(i,:)';
    r.(ch{i}).mgps = mgps;
    r.(ch{i}).stdgps = stdgps;
end