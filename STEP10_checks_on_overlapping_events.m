function [BEGINNING_RAIN, END_RAIN, BEGINNING_FLOW, END_FLOW]=STEP10_checks_on_overlapping_events(beginning_rain_ungrouped, end_rain_ungrouped, beginning_flow_ungrouped, end_flow_ungrouped, time)
%This function scans the list of rain-flow events and group toghether the
%overlapping ones.

%INPUT
%beginning_rain_ungrouped: beginning rain as sequantial number after removing invalid rain-flow events
%end_rain_ungrouped: end rain as sequantial number after removing invalid rain-flow events
%beginning_flow_ungrouped: beginning flow as sequantial number after removing invalid rain-flow events
%end_flow_ungrouped: end flow as sequantial number after removing invalid rain-flow events

%OUTPUT
%BEGINNING_RAIN:beginning of rain events as matlab date
%END_RAIN: end of rain events as matlab date
%BEGINNING_FLOW: beginning of flow events as matlab date
%END_FLOW: end of flow events as matlab date

    q=1;
    marker_overlapping=[];
    for g=1:length(end_rain_ungrouped)-1
        if end_rain_ungrouped(g)> beginning_rain_ungrouped(g+1) | end_flow_ungrouped(g)> beginning_flow_ungrouped(g+1)
            marker_overlapping(q)=g;
            q=q+1;
        end
    end
    
    if isempty(marker_overlapping)==0
    for q=1:length(marker_overlapping)
        to_group= marker_overlapping(q);
        while q<length(marker_overlapping) & marker_overlapping(q)==marker_overlapping(q+1)-1
            to_group=[to_group, marker_overlapping(q+1)];
            q=q+1;
        end
        beginning_rain_ungrouped(to_group(1))=beginning_rain_ungrouped(to_group(1));
        beginning_flow_ungrouped(to_group(1))=beginning_flow_ungrouped(to_group(1));
        end_flow_ungrouped(to_group(1))=end_flow_ungrouped(to_group(end)+1);
        end_rain_ungrouped(to_group(1))=end_rain_ungrouped(to_group(end)+1);
        if length(to_group)>1
            beginning_rain_ungrouped(to_group(2:end))=NaN;
            beginning_flow_ungrouped(to_group(2:end))=NaN;
            end_flow_ungrouped(to_group(2:end))=NaN;
            end_rain_ungrouped(to_group(2:end))=NaN;
        end
        beginning_rain_ungrouped(to_group(end)+1)=NaN;
        beginning_flow_ungrouped(to_group(end)+1)=NaN;
        end_flow_ungrouped(to_group(end)+1)=NaN;
        end_rain_ungrouped(to_group(end)+1)=NaN;
        to_group=[];
    end
    end
    
    index_events2=find(isnan(beginning_rain_ungrouped)==0 & isnan(beginning_flow_ungrouped)==0 & isnan(end_rain_ungrouped)==0 & isnan(end_flow_ungrouped)==0);
    beginning_flow_grouped=beginning_flow_ungrouped(index_events2);
    end_flow_grouped=end_flow_ungrouped(index_events2);
    beginning_rain_grouped=beginning_rain_ungrouped(index_events2);
    end_rain_grouped=end_rain_ungrouped(index_events2);
    
    BEGINNING_RAIN=time(beginning_rain_grouped);
    END_RAIN=time(end_rain_grouped);
    END_FLOW=time(end_flow_grouped);
    BEGINNING_FLOW=time(beginning_flow_grouped);
end