% Calculates the Shockley-Read-Hall recombination rate within unit volume
%
%
%
%
% Inputs-
% n - electron concentration
% p - hole concentration
% n_i - intrinsic carrier concentration
% tau_SRH- Shockley-Read-Hall lifetime
%
%
%
% tau_SRH_unit_vol - SRH recombination rate within unit volume

function [tau_SRH_unit_vol] = SRH_calc(n,p,n_i,tau_SRH)


        tau_SRH_unit_vol = (n.*p-n_i.^2)./(tau_SRH.*(n+p+2*n_i));
    

end

