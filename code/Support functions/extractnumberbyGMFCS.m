function r = extractnumberbyGMFCS(fld)

% R = extractnumberbyGMFCS(fld) extracts number of subjects for each GMFCS level 
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%
% RETURNS
%  r           ...    Number of participant by GMFCS level (structured array)

cd(fld)

r = struct;
s = filesep; 
group = {'Level1','Level2','Level3','UnknownGMFCS'};
    
    fld = [fld,s,'CPOFM'];
    [subjects] = extract_filestruct(fld);
    
    group1 = 0;
    group2 = 0;
    group3 = 0;
    group4 = 0;
    
    for j = 1:length(subjects)

        file = engine('path',[fld,s,subjects{j}],'extension','zoo');
        
        if ~isempty(file)
           data = zload(file{1});

               if data.zoosystem.Anthro.GMFCS(1)== 1
                   group1 = group1 + 1;

               elseif data.zoosystem.Anthro.GMFCS(1) == 2 
                   group2 = group2 + 1;
               
               elseif data.zoosystem.Anthro.GMFCS(1) == 3
                   group3 = group3 + 1;

               elseif data.zoosystem.Anthro.GMFCS(1) == 0 
                  disp([subjects{j} ' has an unknown GMFCS level'])
                  group4 = group4 + 1;
               
               else
                  disp([subjects{j} ' has an unknown GMFCS level'])
                  group4 = group4 + 1;
               end
         end
    end
r.(group{1})= group1;                                              
r.(group{2})= group2; 
r.(group{3})= group3;
r.(group{4})= group4;
end