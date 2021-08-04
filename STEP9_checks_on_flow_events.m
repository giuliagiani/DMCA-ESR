function [beginning_rain_ungrouped, end_rain_ungrouped, beginning_flow_ungrouped, end_flow_ungrouped]=STEP9_checks_on_flow_events(beginning_rain_checked, end_rain_checked, beginning_flow, end_flow,  fluct_flow_Tr)
%This function checks for anomalies in the identified flow events such as
%events that end before starting or with unexpected fluctuations signs
%(expected signs: negative before centre of mass, positive after centre of
%mass). The function discards those events and the associated rainfall
%ones.

%INPUT
%beginning_rain_checked: beginning_rain as sequantial number but anamalous events are marked as NaN
%end_rain_checked: end_rain as sequential number but anamalous events are marked as NaN
%beginning_flow: vector containing start delimiter of each flow event (as sequential number)
%end_flow: vector containing end delimiter of each flow event (as sequential number)
%fluct_flow_Tr: flow fluctuations with window associated to catchment response time

%OUTPUT
%beginning_rain_ungrouped: beginning rain as sequantial number after removing invalid rain-flow events
%end_rain_ungrouped: end rain as sequantial number after removing invalid rain-flow events
%beginning_flow_ungrouped: beginning flow as sequantial number after removing invalid rain-flow events
%end_flow_ungrouped: end flow as sequantial number after removing invalid rain-flow events

    for g=1:length(beginning_flow)

           if isnan(beginning_flow(g))==0 & isnan(end_flow(g))==0 &(end_flow(g)<=beginning_flow(g) | fluct_flow_Tr(beginning_flow(g))>0 |  fluct_flow_Tr(end_flow(g))<0 | beginning_flow(g)<beginning_rain_checked(g)| end_flow(g)<end_rain_checked(g)) 
               beginning_flow_checked(g)=NaN;
               end_flow_checked(g)=NaN;
           else
               beginning_flow_checked(g)=beginning_flow(g);
               end_flow_checked(g)=end_flow(g);
           end
    end
    
    %selecting only events which have both a valid rain and flow event
    index_events=find(isnan(beginning_rain_checked)==0 & isnan(beginning_flow_checked)==0 & isnan(end_rain_checked)==0 & isnan(end_flow_checked)==0);
    beginning_flow_ungrouped=beginning_flow_checked(index_events);
    end_flow_ungrouped=end_flow_checked(index_events);
    beginning_rain_ungrouped=beginning_rain_checked(index_events);
    end_rain_ungrouped=end_rain_checked(index_events);
end