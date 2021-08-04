function  [beginning_flow]=STEP8_beginning_flow_events(beginning_rain_checked, end_rain_checked, end_flow, beginning_core, fluct_rain_Tr, fluct_flow_Tr)
%Starting from the rain event delimiters, this fanction set the start delimiters of
%the flow events.

%INPUT
%beginning_rain_checked: vector containing the beginning of each rain event checked for anomilies (as sequential number)
%end_rain_checked: vector containing the end of each rain event checked for anomalies (as sequential number)
%beginning_core: vector containing the beginning of each core (as sequential number)
%end_flow: vector containing end delimiter of each flow event (as sequential number)
%fluct_rain_Tr: rain fluctuations with window associated to catchment
%               response time corrected using the rainfall fluctuation
%               tolerance
%fluct_flow_Tr: flow fluctuations with window associated to catchment response time

%OUTPUT
%beginning_flow: vector containing start delimiter of each flow event (as sequential number)

    %ROUTINE
    for g=1:length(beginning_rain_checked)
        %ANALYSING FLOW ONLY FOR THOSE CORES WHICH HAVE GENERATED A
        %VALID RAIN EVENT
        if isnan(beginning_rain_checked(g))==0 & isnan(end_rain_checked(g))==0
            
            %BEFORE CORE STARTS RAIN FLUCTUATIONS ARE ZERO (case 1):
            %from the beginning of rain event we move forward in time until
            %the flow fluctuations become negative (this search is bounded 
            %by the end of the flow event) 
            if beginning_core(g)>2 & sum(fluct_rain_Tr(beginning_core(g)-2:beginning_core(g)-1)==0)==2 
                
                %PRELIMINARY GUESS
                beginning_flow(g)= beginning_rain_checked(g);
                
                    while fluct_flow_Tr(beginning_flow(g))>0 & beginning_flow(g)<end_flow(g)
                        beginning_flow(g)=beginning_flow(g)+1;
                    end
                    
            else 
                %BEFORE THE CORE STARTS FLOW FLUCTUATIONS ARE ZERO (case 2):
                %from the beginning of the core we move forward in time until
                %the flow fluctuations become negative (this search is bounded 
                %by the end of the flow event) 
                 
                 %PRELIMINARY GUESS
                 beginning_flow(g)=beginning_core(g);
                    
                    while beginning_flow(g)<=end_flow(g) & fluct_flow_Tr(beginning_flow(g))>=0
                        beginning_flow(g)=beginning_flow(g)+1;
                    end
                end
        else 
        %NOT ASSIGNING ANY FLOW EVENT TO CORES WHICH DO NOT GENERATE A VALID RAIN EVENT
            beginning_flow(g)=NaN;
            end_flow(g)=NaN;
        end
    end
end