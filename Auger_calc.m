% Calculates the Ager recombination rate within unit volume
%
%
%
%
% Inputs-
% n - electron concentration
% p - hole concentration
% n_i - intrinsic carrier concentration
% Cn, Cp - Auger coefficient for electron and holes respectively
%
%
%
% tau_Auger_unit_vol - SRH recombination rate within unit volume

function [tau_Auger_unit_vol] = Auger_calc(n,p,n_i,Cn,Cp)


        tau_Auger_unit_vol = (Cn.*n+Cp.*p).*(n.*p-n_i.^2);
    

end
