function r = extractgpsdata_CP(fld,group,ch,gps)

% R = EXTRACTGPSDATA_CP(fld,group,subjects,ch,gps) extracts GPS data from zoo file
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%  group       ...    List of groups (cell array of strings)
%  ch          ...    Channel to analyse (string)
%  gps         ...    gps value to analyse (string)
%
% RETURNS
%  r           ...    Anthro data by group (structured array)

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
            
            for l = 1:length(file)
            data = zload(file{l});

               if data.zoosystem.Anthro.GMFCS(1)== 1
                   if isfield(data.(ch).event,gps)
                   gpsval = findfield(data.(ch),gps); 
                   group1(j) = gpsval(2);
                   end
               end

               if data.zoosystem.Anthro.GMFCS(1) == 2
                   if isfield(data.(ch).event,gps)
                   gpsval = findfield(data.(ch),gps); 
                   group2(j) = gpsval(2);
                   end
               end 
               
               if data.zoosystem.Anthro.GMFCS(1) == 3
                   if isfield(data.(ch).event,gps)
                   gpsval = findfield(data.(ch),gps); 
                   group3(j) = gpsval(2);
                   end
               end 

               if data.zoosystem.Anthro.GMFCS(1) == 0                                
               end 
            end
        end
    end
r.(group{1})= group1;                                              
r.(group{2})= group2; 
end
