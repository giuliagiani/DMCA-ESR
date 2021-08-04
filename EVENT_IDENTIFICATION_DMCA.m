function [BEGINNING_RAIN, END_RAIN, BEGINNING_FLOW, END_FLOW]= EVENT_IDENTIFICATION_DMCA (rain, flow, time, rain_min, max_window)
%This function allows to identify rainfall-streamflow or rainfall-runoff events.

%INPUT:
%rain: rainfall time series as a n x 1 row vector [mm/h]
%flow: streamflow or runoff time series as a n x 1 row vector [mm/h]
%time: time stamps as a n x 1 vector (datenum) 
%rain_min: minimum rainfall intensity considered significant at the
%          resolution of the data (e.g. 0.1 mm/h or follow guidelines in Appendix A) [mm/h]
%max_window: maximum window tested for the estimate of catchment response time. Set it sensibly according to the
%            resolution of your data (e.g. hourly data, max_window=300 means that the
%            catchment response time can be maximum 300hours/2 = 150hours =~ 6days)[-]

%OUTPUT
%BEGINNING_RAIN: beginning of events in datenum
%END_RAIN: end rain in datenum
%BEGINNING_FLOW:beginning floe in datenum
%END_FLOW: end flow in datenum


%ROUTINE

%STEP1 and STEP2: Tr + rainfall and flow fluctuations associated to Tr
%corrected with tolerance
[Tr, fluct_rain_Tr, fluct_flow_Tr, fluct_bivariate_Tr]= STEP1_STEP2_Tr_and_fluctuations_timeseries (rain, flow, rain_min, max_window);

%STEP3: Core identification
[beginning_core, end_core]= STEP3_core_identification(fluct_bivariate_Tr);

%STEP4: Identification of the end of rain events
[end_rain]=STEP4_end_rain_events(beginning_core, end_core, rain, fluct_rain_Tr, rain_min);

%STEP5: Identification of the beginning of rain events
[beginning_rain]=STEP5_beginning_rain_events(beginning_core, end_rain, rain, fluct_rain_Tr, rain_min);

%STEP6: Checks on rain events
[beginning_rain_checked, end_rain_checked]=STEP6_checks_on_rain_events(beginning_rain, end_rain, rain, rain_min);

%STEP7: Identification of the end of flow events
[end_flow]=STEP7_end_flow_events(beginning_rain_checked, end_rain_checked, beginning_core, end_core, flow, fluct_rain_Tr, fluct_flow_Tr, Tr);

%STEP8: Identification of the beginning of flow events
[beginning_flow]=STEP8_beginning_flow_events(beginning_rain_checked, end_rain_checked, end_flow, beginning_core, fluct_rain_Tr, fluct_flow_Tr);

%STEP9: Checks on flow events and list of rain-flow events
[beginning_rain_ungrouped, end_rain_ungrouped, beginning_flow_ungrouped, end_flow_ungrouped]=STEP9_checks_on_flow_events(beginning_rain_checked, end_rain_checked, beginning_flow, end_flow,  fluct_flow_Tr);

%STEP10: Grouping together overlapping events
[BEGINNING_RAIN, END_RAIN, BEGINNING_FLOW, END_FLOW]=STEP10_checks_on_overlapping_events(beginning_rain_ungrouped, end_rain_ungrouped, beginning_flow_ungrouped, end_flow_ungrouped, time);