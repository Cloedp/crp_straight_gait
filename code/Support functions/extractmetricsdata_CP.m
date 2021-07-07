function r = extractmetricsdata_CP(fld,group,metrics,evt)

% R = EXTRACTGPSDATA_CP(fld,group,metrics, evt) extracts metrics data from zoo file
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%  group       ...    List of groups (cell array of strings)
%  metrics     ...    metrics value to analyse (string)
%  evt         ...    Events to look at
%
% RETURNS
%  r           ...    Metrics data by group (structured array)

cd(fld)

if ~iscell(group)
    group = {group};
end


r = struct;
s = filesep;                                                    % determines slash direction
    
    fld = [fld,s,'CPOFM'];
    [subjects] = extract_filestruct(fld);
    trials = engine('fld',fld,'extension','zoo');
    
    group1 = NaN*ones(length(trials),1);
    group2 = NaN*ones(length(trials),1);
    group3 = NaN*ones(length(trials),1);
    
    for j = 1:length(subjects)

        file = engine('path',[fld,s,subjects{j}],'extension','zoo');
        
        if ~isempty(file)
           data = zload(file{1});
           evtval = findfield(data.(metrics).event,evt);

               if data.zoosystem.Anthro.GMFCS(1)== 1
                   metricsval = evtval(2); 
                   group1(j) = metricsval;
               end

               if data.zoosystem.Anthro.GMFCS(1) == 2
                   metricsval = evtval(2); 
                   group2(j) = metricsval;
               end 
               
               if data.zoosystem.Anthro.GMFCS(1) == 3
                   metricsval = evtval(2); 
                   group3(j) = metricsval;
               end 

               if data.zoosystem.Anthro.GMFCS(1) == 0                                
               end 
         end
    end
r.(group{1})= group1;                                              
r.(group{2})= group2; 
r.(group{3})= group3; 
end