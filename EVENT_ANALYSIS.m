function [DURATION_RAIN, VOLUME_RAIN, DURATION_RUNOFF, VOLUME_RUNOFF, RUNOFF_RATIO]= EVENT_ANALYSIS (BEGINNING_RAIN, END_RAIN, BEGINNING_FLOW, END_FLOW, rain, flow, time, flag, multiple)
%This function calculates durations, volumes and runoff ratio for the
%events identified with the function "EVENT_IDENTIFICATION_DMCA.m".

%INPUT
%BEGINNING_RAIN:beginning of rain events as matlab date
%END_RAIN: end of rain events as matlab date
%BEGINNING_FLOW: beginning of flow events as matlab date
%END_FLOW: end of flow events as matlab date
%rain: rainfall time series as a n x 1 row vector [mm/h]
%flow: streamflow or runoff time series as a n x 1 row vector [mm/h]
%time: time stamps as a n x 1 vector (datenum)
%flag: describe if the flow used for the event identification is total
%      streamflow (flag=0) or only runoff (flag=1)
%multiple: to convert from hourly to the time step of your data

%OUTPUT
%DURATION_RAIN: duration rain events [time step of your data]
%VOLUME_RAIN: volume rain events [mm]
%DURATION_FLOW: duration runoff events [time step of your data]
%VOLUME_RUNOFF: volume runoff events [mm]
%RUNOFF_RATIO: volume rain/volume runoff for each event [-]

%ROUTINE
for h=1:length(BEGINNING_RAIN)
    DURATION_RAIN(h)=etime(datevec(END_RAIN(h)),datevec(BEGINNING_RAIN(h)))./(60*60*multiple);
end

for h=1:length(BEGINNING_FLOW)
    DURATION_RUNOFF(h)=etime(datevec(END_FLOW(h)),datevec(BEGINNING_FLOW(h)))./(60*60*multiple);
end

for h=1:length(BEGINNING_RAIN)
    index_beginning_event=find(time==BEGINNING_RAIN(h));
    index_end_event=find(time==END_RAIN(h));
    VOLUME_RAIN(h)=nansum(rain(index_beginning_event:index_end_event)).*multiple;
end

if flag==1
    for h=1:length(BEGINNING_FLOW)
        index_beginning_event=find(time==BEGINNING_FLOW(h));
        index_end_event=find(time==END_FLOW(h));
        VOLUME_RUNOFF(h)=nansum(flow(index_beginning_event:index_end_event)).*multiple;
    end
else
    baseflow=BASEFLOW_CURVE(BEGINNING_FLOW, END_FLOW, flow, time);
    for h=1:length(BEGINNING_FLOW)
        index_beginning_event=find(time==BEGINNING_FLOW(h));
        index_end_event=find(time==END_FLOW(h));
        q=flow(index_beginning_event:index_end_event); 
        qb=baseflow(index_beginning_event:index_end_event); 
        VOLUME_RUNOFF(h)=nansum(q-qb).*multiple;
    end
end

RUNOFF_RATIO=VOLUME_RUNOFF./VOLUME_RAIN;
end