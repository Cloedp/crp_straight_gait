function r = extractgpsdata(fld,group,ch,gps)

% R = EXTRACTGPSDATA(fld,group,subjects,ch,gps) extracts event data from zoo file
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

for i = 1:length(group)
    subjects = extract_filestruct(group{i});
    estk = NaN*ones(length(subjects),1);
    
    for j = 1:length(subjects)

        file = engine('path',[fld,s,group{i},s,subjects{j}],'extension','zoo');
        
        if ~isempty(file)
            data = zload(file{1});
            gpsval = findfield(data.(ch),gps);
            if ~isempty(gpsval)
                estk(j) = gpsval(2); 
            end
            if isempty(gpsval)                                   
               gpsval = NaN;
               estk(j) = gpsval;
            end  
        end
        
    end
    r.(group{i})= estk;                                               % save to struct
end
