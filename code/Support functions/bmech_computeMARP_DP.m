function bmech_computeMARP_DP(fld,jointcouple, condition)
% This function batch compute the Mean Absolute Relative Phase (MARP)and
% Deviation Phase (DP)and add the MARP and DP values as a channel in all
% files for every subjects if sufficients. 
% 

%   fld         ...  folder to batch compute the MARP
%   jointcouple ...  KH (knee-hip) or AK (ankle-knee)
%   condition   ...  if files contain the name of a condition (p.ex. speed,
%   surface, task..) or, all files for the subject will be selected for the calculation.

cd(fld)

if nargin==1
    error('Not enough input arguments')
end

if nargin==2
    condition = '.zoo';
    cond = 'no specific condition';
end

if nargin==3
   cond = condition;
end

[~,subjects] = extract_filestruct(fld);

for s = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{s}, 'search file', condition);
        if size(fl) < 2
        batchdisp(subjects{s},'insufficient trials for CRP analysis')
        break

        else    

            if contains(jointcouple,'KH')
               KH_CRP_stk = ones(length(fl),101); 

                for i = 1:length(fl)
                    data = zload(fl{i}); 
                    KH_CRP_stk(i,:) = data.HipAnglesPhase_x_KneeAnglesPhase_x_crp.line;   
                end 
                    disp(['computing Knee-Hip MARP & DP for: ',subjects{s},' / condition: ', cond])
                    KH_MARP = mean(KH_CRP_stk);
                    KH_MARP = KH_MARP';
                    KH_DP = std(KH_CRP_stk);
                    KH_DP = KH_DP';

                    for i = 1:length(fl)  
                       data = zload(fl{i});
                       data.KH_MARP.line = KH_MARP;
                       data.KH_DP.line = KH_DP;
                       zsave(fl{i}, data) 
                    end
            end 
            if contains(jointcouple,'AK')
               AK_CRP_stk = ones(length(fl), 101);
                for i = 1:length(fl)
                    data = zload(fl{i});
                    AK_CRP_stk(i,:) = data.KneeAnglesPhase_xLAnkleAnglesPhase_x_crp.line;
                end 
                    disp(['computing Ankle-Knee MARP & DP for: ',subjects{s},' / condition: ', condition])
                    AK_MARP = mean(AK_CRP_stk);
                    AK_MARP = AK_MARP';
                    AK_DP = std(AK_CRP_stk);
                    AK_DP = AK_DP';
                       
                    for i = 1:length(fl)  
                       data = zload(fl{i});
                       data.AK_MARP.line = AK_MARP;
                       data.AK_DP.line = AK_DP;
                       zsave(fl{i}, data) 
                    end
            end 
        end
end 
end

