function bmech_computeMARP_DP(fld)
% This function batch compute the Mean Absolute Relative Phase (MARP)

%   fld    ...  folder to batch compute the MARP

cd(fld)

[~,subjects] = extract_filestruct(fld);

for s = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{s});
        if size(fl) < 2
        disp('insufficient trials for CRP analysis, setting trial as outlier with 999 code')
        else    
        % Preparing data
            for i = length(fl)
                data = zload(fl{i});
                L_KH_CRP_stk = ones(length(fl), 101); 
                L_AK_CRP_stk = ones(length(fl), 101);
            
                L_KH_CRP_stk(i,:) = data.LHipAnglesPhase_x_LKneeAnglesPhase_x_crp.line;
                L_AK_CRP_stk(i,:) = data.LKneeAnglesPhase_x_LAnkleAnglesPhase_x_crp.line;
            end 
            zsave(fl{i}, data)
            
% compute mean absolute relative phase (MARP)  
L_KH_MARP = mean(L_KH_CRP_stk);
L_AK_MARP = mean(L_AK_CRP_stk);
% Compute deviation phase (DP)  
L_KH_DP = std(L_KH_CRP_stk);
L_AK_DP = std(L_AK_CRP_stk);

bmech_addevent(fld,zoosystem,metrics,MARP)
bmech_addevent(fld,zoosystem,metrics,DP)

L_KH_MARP = data.zoosystem.metrics.MARP;
L_AK_MARP = data.zoosystem.metrics.MARP;
L_KH_DP = data.zoosystem.metrics.DP;
L_AK_DP = data.zoosystem.metrics.DP;
zsave(fl{i}, data) 
        end 
end 
