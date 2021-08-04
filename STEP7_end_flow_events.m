function  [end_flow]=STEP7_end_flow_events(beginning_rain_checked, end_rain_checked, beginning_core, end_core, flow, fluct_rain_Tr, fluct_flow_Tr, Tr)
%Starting from the rain event delimiters, this fanction set the end delimiters of
%the flow events.

%INPUT
%beginning_rain_checked: vector containing the beginning of each rain event checked for anomilies (as sequential number)
%end_rain_checked: vector containing the end of each rain event checked for anomalies (as sequential number)
%beginning_core: vector containing the beginning of each core (as sequential number)
%end_core: vector containing the end of each core (as sequential number)
%flow: flow time series as a n x 1 column vector [mm/h]
%fluct_rain_Tr: rain fluctuations with window associated to catchment
%               response time corrected using the rainfall fluctuation
%               tolerance
%fluct_flow_Tr: flow fluctuations with window associated to catchment response time
%Tr: catchment response time in number of timesteps

%OUTPUT
%end_flow: vector containing end delimiter of each flow event (as sequential number)
    
    %ROUTINE
    for g=1:length(end_rain_checked)
            %ANALYSING FLOW ONLY FOR THOSE CORES WHICH HAVE GENERATED A
            %VALID RAIN EVENT
            if isnan(end_rain_checked(g))==0 & isnan(beginning_rain_checked(g))==0 %making sure we have identified a rainfall event 
                
                %CORE ENDS BECAUSE RAIN FLUCTUATIONS ARE ZERO (case 1):
                %from the end of rain event we move forward in time until
                %the end of the positive flow fluctuations (this search is
                %bounded by the beginning of the following rain event+Tr)

                if end_core(g)+2<length(flow) & sum(fluct_rain_Tr(end_core(g)+1:end_core(g)+2)==0)==2 %ended because flutt rain are null
                   %PRELIMINARY GUESS
                   end_flow(g)=end_rain_checked(g);

                   next_event_beginning=find(isnan(beginning_rain_checked(g+1:end))==0);
                   if isempty(next_event_beginning)==0
                        %moving forward until the end of negative
                        %fluct_flow_Tr (in case when rain ends the centre of
                        %mass of flow event hasn't yet come)
                        while end_flow(g)+1<length(flow) & fluct_flow_Tr(end_flow(g))<=0 & end_flow(g)<beginning_rain_checked(g+next_event_beginning(1))+Tr
                            end_flow(g)=end_flow(g)+1;
                        end
                        %moving forward until the end of positive fluct_flow_Tr
                        while end_flow(g)+1<length(flow) & fluct_flow_Tr(end_flow(g))>0 & end_flow(g)<beginning_rain_checked(g+next_event_beginning(1))+Tr
                            end_flow(g)=end_flow(g)+1;
                        end
                        end_flow(g)=end_flow(g)-1;
                   else % for the "last" event
                        %moving forward until the end of negative
                        %fluct_flow_Tr (in case when rain ends the centre of
                        %mass of flow event hasn't yet come)
                        while end_flow(g)+1<length(flow) & fluct_flow_Tr(end_flow(g))<=0 
                            end_flow(g)=end_flow(g)+1;
                        end
                        %moving forward until the end of positive fluct_flow_Tr
                        while end_flow(g)+1<length(flow) & fluct_flow_Tr(end_flow(g))>0 
                            end_flow(g)=end_flow(g)+1;
                        end
                        end_flow(g)=end_flow(g)-1;
                   end
                else
                %CORE ENDS BECAUSE FLOW FLUCTUATIONS ARE ZERO (case 2):
                %from the end of the core we move backward in time until
                %we find positive flow fluctuations (this search is
                %bounded by the beginning of the core of the same event)
                
                    %PRELIMINARY GUESS
                    end_flow(g)=end_core(g);

                    while end_flow(g)>beginning_core(g) & fluct_flow_Tr(end_flow(g))<=0 
                        end_flow(g)=end_flow(g)-1;
                    end
                end
            else
            %NOT ASSIGNING ANY FLOW EVENT TO CORES WHICH DO NOT GENERATE A VALID RAIN EVENT
                end_flow(g)=NaN;
                beginning_flow(g)=NaN;
            end
    end
end