function r = extractevents(fld,group,ch,evt)

% R = EXTRACTEVENTS(fld,group,subjects,ch,evt) extracts event data from zoo file
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%  group        ...   List of groups (cell array of strings)
%  ch          ...    Channel to analyse (string)
%  evt         ...    Event to analyse (string)
%
% RETURNS
%  r           ...    Event data by condition (structured array)

% Revision History
%
% Updated November 2017 by Philippe C. Dixon
% - improved output display

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
        % disp(['loading files for ',subjects{j},' ',group{i}])
        file = engine('path',[fld,s,group{i},s,subjects{j}],'extension','zoo');
        
        if ~isempty(file)
            data = zload(file{1});                              % load zoo file
            evtval = findfield(data.(ch),evt);                  % searches for local event
            
            if isempty(evtval)                                  % searches for global event
                evtval = findfield(data,evt);                   % if local event is not
                evtval(2) = data.(ch).line(evtval(1));          % found
            end
            
            if evtval(2)==999                                   % check for outlier
                evtval(2) = NaN;
            end
            
            estk(j) = evtval(2);                                % add to event stk
        end
        
    end
    r.(group{i})= estk;                                          % save to struct
end
