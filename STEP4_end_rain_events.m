function [end_rain]=STEP4_end_rain_events(beginning_core, end_core, rain, fluct_rain_Tr, rain_min)
%Starting from the core information, this fanction set the end delimiters of
%the rain events.

%INPUT
%beginning_core: vector containing the beginning of each core (as sequential number)
%end_core: vector containing the end of each core (as sequential number)
%rain: rainfall time series as a n x 1 column vector [mm/h]
%fluct_rain_Tr: rain fluctuations with window associated to catchment
%               response time corrected using the rainfall fluctuation
%               tolerance
%rain_min: minimum rainfall intensity considered significant at the
%          resolution of the data (e.g. 0.1 mm/h at hourly scale or follow guidelines in Appendix A) [mm/h]

%OUTPUT
%end_rain: vector containing end delimiter of each rain event (as sequential number)

    %ROUTINE
    
    rain=rain';
    for g=1:length(end_core)

        %PRELIMINARY GUESS
        end_rain(g)=end_core(g);

        %CORE ENDS BECAUSE RAIN FLUCTUATIONS ARE ZERO (case 1 and 2)
        if end_core(g)+2<length(rain) & sum(fluct_rain_Tr(end_core(g)+1:end_core(g)+2)==0)==2

            %WHEN CORE ENDS RAIN IS ZERO (case 1): move backward until find
            %non-zero rainfall
            if rain(end_rain(g))==0 
                while end_rain(g)-1>0 & rain(end_rain(g))==0  
                        end_rain(g)=end_rain(g)-1;
                end
            else
            %WHEN CORE ENDS RAIN IS DIFFERENT FROM ZERO (case 2): move foward
            %until the rain becomes lower than rain_min (search bounded by the
            %beginning of the following core)
                next_core_beginning=find(isnan(beginning_core(g+1:end))==0); 
                if isempty(next_core_beginning)==0 %next core beginning can be empty for the last or close to the end events hence the the if loop below
                    while end_rain(g)+1<length(rain) & rain(end_rain(g))>rain_min & end_rain(g)<beginning_core(g+next_core_beginning(1))
                        end_rain(g)=end_rain(g)+1;
                    end
                    end_rain(g)=end_rain(g)-1;
                else %for the "last" event
                      while end_rain(g)+1<length(rain) & rain(end_rain(g))>rain_min
                        end_rain(g)=end_rain(g)+1;
                      end
                      end_rain(g)=end_rain(g)-1;
                end
            end
        else 
        %CORE ENDS BECAUSE FLOW FLUCTUATIONS ARE ZERO (case 3): move
        %backward until, after an eventual dry (or nearly dry period), we find rainfall
        %larger than rain_min (search bounded by the beginning of the core of the same event)

            %eventual dry of nearly dry period
            while end_rain(g)-1>0 & rain(end_rain(g))>rain_min & end_rain(g)>=beginning_core(g)
                    end_rain(g)=end_rain(g)-1;
            end
            %move back more until rain is larger than rain_min
            while end_rain(g)-1>0 & rain(end_rain(g))<rain_min & end_rain(g)>=beginning_core(g)
                    end_rain(g)=end_rain(g)-1;
            end 

        end
    end
end