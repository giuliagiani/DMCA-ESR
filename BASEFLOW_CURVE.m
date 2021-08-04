function [baseflow]= BASEFLOW_CURVE(BEGINNING_FLOW, END_FLOW, flow, time)
%This function calculates durations, volumes and runoff ratio for the
%events identified with the function "EVENT_IDENTIFICATION_DMCA.m".

%INPUT
%BEGINNING_FLOW: beginning of flow events as matlab date
%END_FLOW: end of flow events as matlab date
%flow: streamflow or runoff time series as a n x 1 row vector [mm/h]
%time: time stamps as a n x 1 vector (datenum) 
%multiple: to convert from hourly to the time step of your data

%OUTPUT
%baseflow: baseflow as n x 1 vector [mm/h]

      %ROUTINE
      baseflow=flow;
      beg_end_series=[];
      for j=1:length(BEGINNING_FLOW)
            beg_end_series=[beg_end_series;BEGINNING_FLOW(j); END_FLOW(j)];
      end
      
    for k=1:length(beg_end_series)-1
        index_beg=find(time== beg_end_series(k));
        index_end=find(time==beg_end_series(k+1));
        if length(find(isnan(flow(index_beg:index_end))==1))>=length(flow(index_beg:index_end))*0.9 %this is to avoid to connect points separated by long periods of NaNs
            baseflow(index_beg:index_end)=NaN;
        elseif index_end-index_beg==1 %in case the event lasts just one time step
             baseflow(index_beg)=flow(index_beg);
             baseflow(index_end)=flow(index_end);
         elseif flow(index_beg)<flow(index_end) %when the value of the streamflow at the beginning is smaller than the value of the streamflow at the end
             increment=(flow(index_end)-flow(index_beg))./(index_end-index_beg);
             for k= index_beg+1: index_end-1
                 baseflow(k)=baseflow(index_beg)+increment*(k-index_beg);
             end
         elseif flow(index_beg)>flow(index_end) %when the value of the streamflow at the beginning is bigger than the value of the streamflow at the end
              increment=(flow(index_beg)-flow(index_end))./(index_end-index_beg);
             for k= index_beg+1: index_end-1
                 baseflow(k)=baseflow(index_beg)-increment*(k-index_beg);
             end
         end
    end
     
     for m=1:length(baseflow) %for when the straight line intersect the streamflow and hence baseflow becomes larger than streamflow
         if baseflow(m)>flow(m)
             baseflow(m)=flow(m);
         end
     end
     
end