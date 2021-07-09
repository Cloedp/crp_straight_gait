function r = extractnumberbygroup(fld)

% R = extractnumberbygroup(fld) extracts number of subjects for each group
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%
% RETURNS
%  r           ...    Number of participant by group (structured array)

cd(fld)

r = struct;
s = filesep; 

group = {'CPOFM','Aschau_NORM'};
group1 = 0;
group2 = 0;

for g = 1:length(group)
    
    if g == 1
    groupfld = [fld,s,group{g}];
    end
    if g == 2
    groupfld =[fld,s,group{g}];
    end 
    
    [subjects] = extract_filestruct(groupfld);
    
    for j = 1:length(subjects)

        file = engine('path',[groupfld,s,subjects{j}],'extension','zoo');
        
        if ~isempty(file)
           data = zload(file{1});

               if strcmp(group{g},'CPOFM')
                   group1 = group1 + 1;

               elseif strcmp(group{g},'Aschau_NORM') 
                   group2 = group2 + 1;
               
               end
         end
    end
end
r.(group{1})= group1;                                              
r.(group{2})= group2; 
end