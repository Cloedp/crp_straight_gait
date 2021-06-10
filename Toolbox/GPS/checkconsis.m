function checkconsis(sub,sidestk,GPSstk)

% check consistency amongs straight trials
fl = engine('path',sub,'extension','zoo');

sidestk(cellfun(@isempty,sidestk)) = [];   % That's some hot programming
sides1 = unique(sidestk);

if length(sides1)>1 && nanmean(GPSstk)>1.6
    
    disp('Different sides selected for more affected!')
    
    if isin(sub,'TD')
        
        for d = 1:length(fl)
            delfile(fl{d})
        end
        rmdir(sub)
        
    else
        error('remove bad trial')
    end
    
elseif length(sides1)>1 && nanmean(GPSstk)<1.6
    fix = 'yes';
    disp('small disagreement across sides, picking random side')
    side = sidestk{1}; % this is random
elseif isempty(sides1)
    disp('deleting subject with no straight trials')
    rmdir(sub,'s')
else
    fix = 'no';
    side = sides1{1}; % there is only 1 and it is always the same
    
end

fl = engine('path',sub,'extension','zoo');

for j = 1:length(fl)  % cycle through again correcting turning
    
    data = zload(fl{j});
    
    
    if ~isin(data.zoosystem.CompInfo.Condition,'Straight')
        cside = data.zoosystem.CompInfo.GC_MoreAffectedSide;
        
        if cside ~=side
            batchdisplay(fl{j},'correcting MA limb based on straight')
            data.zoosystem.CompInfo.GC_MoreAffectedSide = sidestk{1};
            save(fl{j},'data');
        end
        
    elseif isin( data.zoosystem.CompInfo.Condition,'Straight') && isin(fix,'yes')
        cside = data.zoosystem.CompInfo.GC_MoreAffectedSide;
        
        if cside ~=side
            batchdisplay(fl{j},'making all straight the same ')
            data.zoosystem.CompInfo.GC_MoreAffectedSide = side;
            save(fl{j},'data');
        end
        
    end  
end
end