% calculates Shockley-VanRoosebroeck relation for a material
%
%
%
% Inputs:
% V - Bias voltage applied to the semiconductor
% E - array of energy values
% n - free electron concentration
% p - hole concentration 
% Eg_InGaAs - bandgap of the material
%
% Outputs:
% B - radiative recombination coefficient

function[B] = SVR(V,E,n,p,alpha,nr,Tc)
    
    fund_consts;
    
    
    f = E/h; % calculating the frequency
    
    tot = 8*pi*nr^2*f.^2.*alpha.*exp((q*V-E)/(kb*Tc))/c^2; % dummy variable, radiative recombination rate within unit frequency band
    
    B = trapz(f,tot./(n*p));
    
    
    
    
    

    
    

end