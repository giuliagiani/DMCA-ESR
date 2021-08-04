function [beginning_rain_checked, end_rain_checked]=STEP6_checks_on_rain_events(beginning_rain, end_rain, rain, rain_min)
%This function checks for anomalies in the identified rain events such as
%events that end before starting or not delimited by period of rain lower
%than rain_min

%INPUT
%beginning_rain: vector containing the beginning of each rain event (as sequential number)
%end_core: vector containing the end of each rain event (as sequential number)
%rain: rainfall time series as a n x 1 column vector [mm/h]
%rain_min: minimum rainfall intensity considered significant at the
%          resolution of the data (e.g. 0.1 mm/h at hourly scale or follow guidelines in Appendix A) [mm/h]

%OUTPUT
%beginning_rain_checked: beginning_rain but anamalous events are marked as NaN
%end_rain_checked: end_rain but anamalous events are marked as NaN

   %ROUTINE
   rain=rain';
   for g=1:length(beginning_rain)
       if beginning_rain(g)>end_rain(g)| rain(beginning_rain(g)-1)>rain_min | rain(end_rain(g)+1)>rain_min
           beginning_rain_checked(g)=NaN;
           end_rain_checked(g)=NaN;
       else
           beginning_rain_checked(g)=beginning_rain(g);
           end_rain_checked(g)=end_rain(g);
       end
   end
end