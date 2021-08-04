function [beginning_core, end_core]= STEP3_core_identification(fluct_bivariate_Tr)
%This functions identifies the cores of the events (period within each
%event when both rainand flow are fluctuating) from the bivariate
%fluctuation time series associated to Tr

%INPUT 
%fluct_bivariate_Tr:product of fluct_rain_Tr and fluct_flow_Tr 
%                   (i.e. product of rain fluctuations (corrected with the rain fluctuation tolerance)
%                   and flow fluctuations)  

%OUTPUT
%beginning_core: vector containing the beginning of each core (as sequential number)
%end_core: vector containing the end of each core (as sequential number)

    %ROUTINE

    g=1;
    q=1;
    while q+1<=(length(fluct_bivariate_Tr))
        if abs(fluct_bivariate_Tr(q))> 0
            beginning_core(g)=q;
            while q+1<length(fluct_bivariate_Tr)  && sum(abs(fluct_bivariate_Tr(q:q+1)))>0 %we want two consecutive timestep of zero fluctuations to end the core (one can just be a change of sign)
                  q=q+1;
                  if q>=(length(fluct_bivariate_Tr)) %break when we finish scanning the entire time series
                      break
                  end
            end
            end_core(g)=q-1;
            g=g+1;
        end
        q=q+1;
    end
end