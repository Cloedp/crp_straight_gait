function bmech_delete_too_short(fld, chns)
% This function removes trials that have unsufficient frames for partition 
% a complete Left gait cycle (FS1 to FS2)

% ARGUMENTS
%  fld        ...  Folder to batch process (string). 
%  chns       ...  Channels for which to look at number of frames. Channels must be 1 x n (exploded)

cd(fld)
fl = engine('path',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});  
    for c = length(chns)
        if length(data.(chns{c}).line) <= data.SACR_x.event.LFS2(1)
        delete(fl{i});
        batchdisp(fl{i},'deleting trials because of unsufficient frames for partition');
        end
    end
end 

