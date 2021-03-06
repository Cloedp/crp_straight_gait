function [gps_r,gps_l,r]  = computegps(data,ndata, ch_gps, RightFS1,RightFS2,LeftFS1,LeftFS2)

% Notes
% - uses standard events from vicon

%  RightFS1     ...   Name of the event Right Foot Strike 1
%  RightFS2     ...   Name of the event Right Foot Strike 2
%  LeftFS1      ...   Name of the event Left Foot Strike 1
%  LeftFS2      ...   Name of the event Left Foot Strike 2
% Updated May 18th 2013
% - uses appropriate RMS calculation

nlength = 101;
    

%--extract foot strike events and foot strike order ----------------
[FS, side_order] = extract_foot_strike_events(data,RightFS1,RightFS2,LeftFS1,LeftFS2);

if ~isempty(find(FS== 999, 1))
    gps_r = 999;
    gps_l = 999;
    r = 999;
    return
end

%---compute GVS for all available variables----------
gvsstk_r = NaN*zeros(length(ch_gps),1);    % L
gvsstk_l = NaN*zeros(length(ch_gps),1);    % R
r = struct;
for i =1:length(ch_gps)
    
    for j = 1:length(side_order) % left and right side_order
        
        if isfield(data,[side_order{j},ch_gps{i}])
            sub = normalize_line(data.([side_order{j},ch_gps{i}]).line(FS(2*j-1):FS(2*j)),nlength-1);
          
        elseif ~isfield(data,[side_order{j},ch_gps{i}])
            sub = NaN;
        end
        
        ref = ndata.(ch_gps{i}).line;      % norm data
        gvs = rmse(sub,ref);
        
        % for testing
%         close all
%         figure
%         plot(ref)
%         hold on
%         plot(sub)
%         legend('reference', 'subject')
%         title([side_order{j}, ch_gps{i}]);
        
        r.([side_order{j},ch_gps{i}]).line =sub;   % put in all original data
        r.([side_order{j},ch_gps{i}]).event.gvs = [1 gvs 0];    % make as real event
            
        if strfind(side_order{j},'R') % && ~isin(ch_gps{i},'Pelvis') % Do not put==1 && ~isin(ch_gps{i},'AnkleAngles_z') && ~isin(ch_gps{i},'KneeAngles_y') && ~isin(ch_gps{i},'Pelvis')  % Right side
            gvsstk_r(i) = gvs;
        else
            gvsstk_l(i) = gvs;
        end
        
    end
end

gps_r = nanmean(gvsstk_r);                       
gps_l= nanmean(gvsstk_l);              


function [FS, side_order] = extract_foot_strike_events(data, RightFS1,RightFS2,LeftFS1,LeftFS2)

[LFS1, ech] = findfield(data, LeftFS1);
LFS2 = findfield(data, LeftFS2);
RFS1 = findfield(data, RightFS1);
RFS2 = findfield(data, RightFS2);

if LFS1(1) < RFS1(1)
    startfoot = 'Left';
    side_order = {'L', 'R'};
else
    startfoot = 'Right';
    side_order = {'R', 'L'};
end

if isin(startfoot,'Left')
    
    a1 =  data.(ech).event.LFS1(1);
    b1 =  data.(ech).event.RFS1(1);

    if isfield(data.(ech).event,LeftFS2) 
        a2 = data.(ech).event.LFS2(1);
    else
        a2 = [999, 0, 0];
    end
    
    if isfield(data.(ech).event,RightFS2) 
        b2 = data.(ech).event.RFS2(1);
    else
        b2 = [999, 0, 0];
    end
    
    
elseif isin(startfoot,'Right')
    
    a1 =  data.(ech).event.RFS1(1);
    b1 =  data.(ech).event.LFS1(1);
    
    if isfield(data.(ech).event,RightFS2) 
        a2 = data.(ech).event.RFS2(1);
    else
        warning('insufficient right foot strikes for GPS analysis')
        a2 = 999;
    end
    
    if isfield(data.(ech).event,LeftFS2) 
        b2 = data.(ech).event.LFS2(1);
    else
        warning('insufficient left foot strikes for GPS analysis')
        b2 = 999;
    end
    
end

FS = [a1,a2,b1,b2];



