function [data,side] = checkprocess(data,dataset,fl)

apexfoot = data.zoosystem.CompInfo.ApexFoot;

%--make sure data is exploded----
%
if ~isfield(data,'SACR_x') % then must explode
    
    ch = setdiff(fieldnames(data),{'zoosystem','L_Rect','R_Rect','L_Hams','R_Hams','L_Gast','R_Gast','L_Tib_Ant',...
        'R_Tib_Ant','L_Spare','R_Spare','L_Tib_Post','R_Tib_Post'});
    chkp = cell(size(ch));
    
    for i =1:length(ch)
        if length(ch{i}) > 5 || ismember(ch{i},{'LKNA','RKNA','LHPA','RHPA','SACR','RPLA','LPLA'})
            chkp{i} = ch{i};
        end
    end
    
    chkp(cellfun(@isempty,chkp)) = [];   % That's some hot programming
    data = explodechannel(data,chkp);
end

%--check that turning data has Ipsi/Contra
%
if isin(dataset,'urn') && ~isfield(data,'IpsiHFTBA_x')
    data = sortsides(data,fl);
end


%---check sides--------------
%
if isfield(data,'IpsiHipAngles_x')
    side = {'Ipsi','Contra'};
    
elseif isfield(data,'RHipAngles_x')
    side = {'R','L'};
    
else
    disp('channel not found')
end

%-------rename to standard GPS names---
%
dim = {'_x','_y','_z'};

oldchstk = {};
newchstk = {};


if ~isfield(data,[side{1},'PLA_x'])
    error('fix pelvis before computing')   
end
    

side1PLA_x = data.([side{1},'PLA_x']).line; % PLAz --> Belfas x
side1PLA_y  = data.([side{1},'PLA_y']).line;
side1PLA_z = data.([side{1},'PLA_z']).line; % PLAx --> Belfast z

side2PLA_x = data.([side{2},'PLA_x']).line; % PLAz --> Belfas x
side2PLA_y = data.([side{2},'PLA_y']).line;
side2PLA_z = data.([side{2},'PLA_z']).line; % PLAx --> Belfast z


% by convention (Baker, 2009) the left side of the pelvis is used...

if isin(apexfoot,'Left') && isin(side{1},'R')
    
    data.([side{1},'PLA_x']).line = -side1PLA_z;
    data.([side{1},'PLA_y']).line = -side1PLA_y;
    data.([side{1},'PLA_z']).line = side1PLA_x;
    
    data.([side{2},'PLA_x']).line = side2PLA_z;
    data.([side{2},'PLA_y']).line = side2PLA_y;
    data.([side{2},'PLA_z']).line = side2PLA_x;
    
elseif isin(apexfoot,'Right') && isin(side{1},'R')
    
    data.([side{1},'PLA_x']).line =  side1PLA_z;
    data.([side{1},'PLA_y']).line =  side1PLA_y;
    data.([side{1},'PLA_z']).line =  side1PLA_x;
    
    data.([side{2},'PLA_x']).line = -side1PLA_z;
    data.([side{2},'PLA_y']).line = -side1PLA_y;
    data.([side{2},'PLA_z']).line = side1PLA_x;
    
elseif isin(apexfoot,'Left') && isin(side{1},'Ipsi')
    
    data.([side{1},'PLA_x']).line = side1PLA_z;
    data.([side{1},'PLA_y']).line = side1PLA_y;
    data.([side{1},'PLA_z']).line = side1PLA_x;
    
    data.([side{2},'PLA_x']).line = -side2PLA_z;
    data.([side{2},'PLA_y']).line = -side2PLA_y;
    data.([side{2},'PLA_z']).line = side2PLA_x;
    
elseif isin(apexfoot,'Right') && isin(side{1},'Ipsi')
    
    data.([side{1},'PLA_x']).line = side1PLA_z;
    data.([side{1},'PLA_y']).line =  side1PLA_y;
    data.([side{1},'PLA_z']).line =  side1PLA_x;
    
    data.([side{2},'PLA_x']).line = -side1PLA_z;
    data.([side{2},'PLA_y']).line = -side1PLA_y;
    data.([side{2},'PLA_z']).line = -side1PLA_x;
    
end




% Channel rename
%
och = {'PLA','HPA','KNA'};                  % use HPA and KNA in place of PiG versions
nch = {'BelfastPelvisAngles','HipAngles','KneeAngles'};

for i = 1:length(och)
    
    for j = 1:length(side)
        
        for k = 1:length(dim)
            
            oldch = [side{j},och{i},dim{k}];
            newch = [side{j},nch{i},dim{k}];
            
            oldchstk = [oldchstk; oldch];
            newchstk = [newchstk; newch];
            
        end
    end
end


if isin(dataset,'gait')
    % Add FPA
    oldchstk = [oldchstk; 'RFPA';'LFPA'];
    newchstk = [newchstk; 'RFootProgressAngles_z'; 'LFootProgressAngles_z'];
    
else
    oldchstk = [oldchstk; 'IpsiFPA';'ContraFPA'];
    newchstk = [newchstk; 'IpsiFootProgressAngles_z'; 'ContraFootProgressAngles_z'];
end


data = renamechannel(data,oldchstk,newchstk,'Video');







% OLD CHEKC PROCSSS----












% 
% 
% function [data,side] = checkprocess(data,dataset,fl)
% 
% 
% %--make sure data is exploded----
% %
% if ~isfield(data,'SACR_x') % then must explode
%             
%     ch = setdiff(fieldnames(data),{'zoosystem','L_Rect','R_Rect','L_Hams','R_Hams','L_Gast','R_Gast','L_Tib_Ant',...
%                                    'R_Tib_Ant','L_Spare','R_Spare','L_Tib_Post','R_Tib_Post'}); 
%     chkp = cell(size(ch));
%     
%     for i =1:length(ch)
%         if length(ch{i}) > 5 || ismember(ch{i},{'LKNA','RKNA','LHPA','RHPA','SACR'})
%         chkp{i} = ch{i};
%         end 
%     end
%     
%     chkp(cellfun(@isempty,chkp)) = [];   % That's some hot programming
%     data = explodechannel(data,chkp);
% end
%     
% 
% %--check that turning data has Ipsi/Contra
% %
% if isin(dataset,'urn') && ~isfield(data,'IpsiHFTBA_x')
%     data = sortsides(data,fl);
% end
% 
% 
% %---check sides--------------
% %
% if isfield(data,'IpsiKneeAngles_x')
%     side = {'Ipsi','Contra'};
%     
% elseif isfield(data,'RKneeAngles_x')
%     side = {'R','L'};
%     
% elseif isfield(data,'LKneeAngles_x') 
%     side = {'R','L'};
% 
% else
%     disp('channel not found')
% end
% 
% 
% %-------rename to standard GPS names---
% %
% dim = {'_x','_y','_z'};
% 
% oldchstk = {};
% newchstk = {};
% 
% 
% if ~isin(dataset,'urn')
%     
%     if isfield(data,'IpsiHFTBA_x') || isfield(data,'RHFTBA_x')
%         
%         och = {'HPA','KNA'};                  % use HPA and KNA in place of PiG versions
%         nch = {'HipAngles','KneeAngles'};
%         
%         for i = 1:length(och)
%             
%             for j = 1:length(side)
%                 
%                 for k = 1:length(dim)
%                     
%                     oldch = [side{j},och{i},dim{k}];
%                     newch = [side{j},nch{i},dim{k}];
%                     
%                     oldchstk = [oldchstk; oldch];
%                     newchstk = [newchstk; newch];
%                     
%                 end
%             end
%         end
%         
%         
%         data = renamechannel(data,oldchstk,newchstk,'Video');
%         
%     end
%     
% end
% 
% 
