function gps_excel(file)

% this function will write appropriate xls data to 8,20 GPS Calculation test in order to get MAP
% and GPS values
%
% NOTE:
% - tested with demotrial.zoo

% Created May 13th 2013 by Philippe Dixon

clc
%---load subject data-----
%
if nargin==0
    [f,p]=uigetfile('*.zoo');
    file = [p,f];
    cd(p)
end



data = zload(file);
age = round(data.zoosystem.Anthro.Age);
sex = data.zoosystem.Anthro.Sex;


%---load normative data
% - All possible channels are output here, but limited set can be chosen
%   afterwards
ch_OGL = {'BelfastPelvisAngles_x','HipAngles_x','KneeAngles_x','AnkleAngles_x',...
    'BelfastPelvisAngles_y','HipAngles_y','KneeAngles_y', ...
    'BelfastPelvisAngles_z','HipAngles_z',               'AnkleAngles_z',...
    'FootProgressAngles_z'}';

group = findgpsgroup(data);

ndata = GetOGLnormGPS(group);

evts = 'Zeni';  % use manual events identified in Vicon


[~,~,r]  = computegps(data,ndata,ch_OGL,'gait cycle',file,evts);


% Get GPS based on Baker channels
%
disp('Based on the Baker channels')

Right = [];
Left = [];

ch = fieldnames(r);

for i = 1:length(ch)
    
    chn = ch{i};
    plate = r.(chn).event.gvs(2);
    
    if isin(chn(1),'L') && ~isin(chn,'AnkleAngles_z') && ~isin(chn,'KneeAngles_y')
        Left = [Left; plate];
    elseif isin(chn(1),'R')  && ~isin(chn,'AnkleAngles_z') && ~isin(chn,'KneeAngles_y') && ~isin(chn,'Pelvis')
        Right = [Right; plate];
    end
   
end

mRight = mean(Right);
mLeft = mean(Left);
    
disp(['GPS R = ',num2str(mRight)])
disp(['GPS L = ',num2str(mLeft)])
disp(['GPS = ',num2str(mean([mLeft,mRight]))] )

if mRight > mLeft +1.6
    disp('R more affected')
elseif mLeft > mRight +1.6
    disp('L more affected')
else
    disp('no asymmetry detected')
end


%---arrange r for excel sheet--

% chn = fieldnames(r);
%
% for i = 1:length(chn)
%     
%     ch = chn{i};
%     
%     if isin(ch,'Ipsi') && isin(con,'LStraight')
%         
%         r.(['R',ch(5:end)]) = r.(ch);
%         r = rmfield(r,ch);
%         
%     elseif  isin(ch,'Contra') && isin(con,'LStraight')
%         r.(['L',ch(7:end)]) = r.(ch);
%         r = rmfield(r,ch);
%         
%     elseif isin(ch,'Ipsi') && isin(con,'RStraight')
%         
%         r.(['L',ch(5:end)]) = r.(ch);
%         r = rmfield(r,ch);
%         
%     elseif  isin(ch,'Contra') && isin(con,'RStraight')
%         r.(['R',ch(7:end)]) = r.(ch);
%         r = rmfield(r,ch);
%     else
%         
%     end
%     
%     
% end

junk = 999*ones(size(r.RHipAngles_x.line));
r.RKneeAngles_z.line = junk;
r.LKneeAngles_z.line = junk;
r.RAnkleAngles_z.line = junk;
r.LAnkleAngles_z.line = junk;


% correction for use of Belfast pelvis angles!
%
Rtemp = r.RBelfastPelvisAngles_x.line;
Ltemp = r.LBelfastPelvisAngles_x.line;

r.RBelfastPelvisAngles_x.line = r.RBelfastPelvisAngles_z.line;
r.LBelfastPelvisAngles_x.line = r.LBelfastPelvisAngles_z.line;

r.RBelfastPelvisAngles_z.line = Rtemp;
r.LBelfastPelvisAngles_z.line = Ltemp;



M = [r.RBelfastPelvisAngles_x.line'; r.LBelfastPelvisAngles_x.line';r.RHipAngles_x.line'; r.LHipAngles_x.line';...
    r.RKneeAngles_x.line'; r.LKneeAngles_x.line';r.RAnkleAngles_x.line'; r.LAnkleAngles_x.line';...
    r.RBelfastPelvisAngles_y.line'; r.LBelfastPelvisAngles_y.line'; r.RHipAngles_y.line'; r.LHipAngles_y.line';...
    r.RKneeAngles_y.line'; r.LKneeAngles_y.line'; r.RBelfastPelvisAngles_z.line'; r.LBelfastPelvisAngles_z.line'; r.RHipAngles_z.line'; r.LHipAngles_z.line';...
    r.RKneeAngles_z.line'; r.LKneeAngles_z.line'; r.RAnkleAngles_z.line'; r.LAnkleAngles_z.line'; r.RFootProgressAngles_z.line';r.LFootProgressAngles_z.line'];

% write matrix to xls


s = slash;
root = which('ensembler.m');
indx = strfind(root,s);
root = root(1:indx(end-1)) ;
root = [root,'Gait',s,'GPS',s];
gpsfile1 = [root,'8.20 GPS Calculation Baker.xlsx'];
gpsfile2 = [root,'8.20 GPS Calculation test.xlsx'];


if isin(computer,'PCWIN')
    
    xlswrite(gpsfile1,M,'Current','E17:DA40');
    xlswrite(gpsfile1,age,'Current','B14');
    xlswrite(gpsfile1,sex,'Current','E14');
    
    
    disp('****************')
    disp('Data written to excel file ')
    disp(['Location: ',gpsfile1])
    
    xlswrite(gpsfile2,M,'Current','E17:DA40');
    xlswrite(gpsfile2,age,'Current','B14');
    xlswrite(gpsfile2,sex,'Current','E14');
    
    
    disp('****************')
    disp('Data written to excel file ')
    disp(['Location: ',gpsfile2])
    
else
    disp('not writing to excel')
    
end


a = 1;