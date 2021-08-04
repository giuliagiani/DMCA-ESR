function [beginning_rain]=STEP5_beginning_rain_events(beginning_core, end_rain, rain, fluct_rain_Tr, rain_min)
%Starting from the core information, this fanction set the start delimiters of
%the rain events.

%INPUT
%beginning_core: vector containing the beginning of each core (as sequential number)
%end_rain: vector containing end delimiter of each rain event (as sequential number)
%rain: rainfall time series as a n x 1 column vector [mm/h]
%fluct_rain_Tr: rain fluctuations with window associated to catchment
%               response time corrected using the rainfall fluctuation
%               tolerance
%rain_min: minimum rainfall intensity considered significant at the
%          resolution of the data (e.g. 0.1 mm/h at hourly scale or follow guidelines in Appendix A) [mm/h]

%OUTPUT
%beginning_rain: vector containing start delimiter of each rain event (as sequential number)
  
  %ROUTINE
  
  rain=rain';
  for g=1:length(beginning_core)
      
      %PRELIMINARY GUESS
      beginning_rain(g)=beginning_core(g);
      
        %BEFORE CORE STARTS RAIN FLUCTUATIONS ARE ZERO (case 1 and 2)
        if beginning_core(g)>2 & sum(fluct_rain_Tr(beginning_core(g)-2:beginning_core(g)-1)==0)==2
            
            %WHEN CORE STARTS RAIN IS ZERO (case 1): move forward until find
            %non-zero rainfall
            if rain(beginning_core(g))==0
                while beginning_rain(g)+1<length(rain) & rain(beginning_rain(g))==0 %this is to account for the error between end of rain_flutt and end of actual rain. Now beginning of rainfall is set at the last timestep of zero rainfall before the event starts. To change it to the first timestep of actual rain just change the second condition in the while to: rain(beginning_rain(g))==0
                    beginning_rain(g)=beginning_rain(g)+1;
                end
            else 
            %WHEN CORE STARTS RAIN IS DIFFERENT FROM ZERO (case 2): move backward
            %until the rain becomes lower than rain_min (search bounded by the
            %end of the previous rain event)
                previous_event_end=find(isnan(end_rain(1:g-1))==0);
                if isempty(previous_event_end)==0 %making sure there are previous cores
                    while beginning_rain(g)-1>0 & rain(beginning_rain(g))>rain_min & beginning_rain(g)>end_rain(previous_event_end(end))
                        beginning_rain(g)=beginning_rain(g)-1;
                    end
                    beginning_rain(g)=beginning_rain(g)+1;
                else %case of "first" event
                    while beginning_rain(g)-1>0 & rain(beginning_rain(g))>rain_min
                        beginning_rain(g)=beginning_rain(g)-1;
                    end
                    beginning_rain(g)=beginning_rain(g)+1;
                end
            end
        else 
        %BEFORE CORE STARTS FLOW FLUCTUATIONS ARE ZERO (case 3): move
        %backward unitl rain becomes lower than rain_min(search bounded by the
        %end of the previous rain event)
            previous_event_end=find(isnan(end_rain(1:g-1))==0);% finding previous cores to boud our serach of beginning of rainfall event
            if isempty(previous_event_end)==0
                while beginning_rain(g)-1>0 & rain(beginning_rain(g))>rain_min & beginning_rain(g)>end_rain(previous_event_end(end))
                    beginning_rain(g)=beginning_rain(g)-1;
                end 
                beginning_rain(g)=beginning_rain(g)+1;
            else %case of "first" event
                while beginning_rain(g)-1>0 & rain(beginning_rain(g))>rain_min
                    beginning_rain(g)=beginning_rain(g)-1;
                end 
                beginning_rain(g)=beginning_rain(g)+1;
            end
        end
  end
end