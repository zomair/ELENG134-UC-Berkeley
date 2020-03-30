% Calculates the blackbody photon flux radiated from an emitter
%
%
%
% Input 
% E- energy in joules
% Tc - temperature of the emitter
%
%Outputs-
% nos- photons emitted/time/area/energy 



function [nos] = blackbody_photon_counts(E,Tc)
    

    %% fundamentals constants
    fund_consts;

    
    %% photon flux
    
    nos =2*pi*E.^2./(c^2*h^3*(exp(E/(kb*Tc))-1));
    
end

