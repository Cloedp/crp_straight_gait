function r = extractanthrodata(fld,group,ch,anthro)

% R = EXTRACTANTHRODATA(fld,group,subjects,ch,evt) extracts event data from zoo file
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%  group       ...    List of groups (cell array of strings)
%  ch          ...    Channel to analyse (string)
%  anthro      ...    Anthro to analyse (string)
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
            if isfield(data.(ch).Anthro,anthro)
            anthroval = findfield(data.(ch),anthro); % searches for local event
                    if ischar(anthroval)
                       anthroval = replace(anthroval,',','.');
                       anthroval = str2double(anthroval);
                    end
            estk(j) = anthroval;
            else
            disp([subjects{j}, ' has no ', anthro, ' data in Anthro'])
            end
        end
    end
    r.(group{i})= estk;  
end
end
