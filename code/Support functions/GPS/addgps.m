function data = addgps(data,GPS_r,GPS_l,r)

ech = 'SACR_x';
%---simple GPS computations
%
gps = nanmean([GPS_r GPS_l]);
gps_diff = abs(GPS_r-GPS_l);

% Add GPS events
data.(ech).event.GPS_R    = [1 GPS_r 0];  % OGL always comes out as side1-->R, side2-->L
data.(ech).event.GPS_L    = [1 GPS_l 0];
data.(ech).event.GPS_diff = [1 gps_diff 0];
data.(ech).event.GPS      = [1 gps 0];

% Add GVS info from r struct
rch = fieldnames(r);
for i = 1:length(rch)
    
    rchn = rch{i};
    under = strfind(rchn,'_');
    dim = rchn(under:end);
    chn = rchn(1:under-1);
    
    data.(rch{i}).event.gvs =  r.(rch{i}).event.gvs;
      
end