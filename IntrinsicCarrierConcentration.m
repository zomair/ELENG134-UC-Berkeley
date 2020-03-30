
%calculates the intrinsic carrier concentration of In(x)Ga(1-x)As
% 
% Input-
% x - composition of Indium 
% Eg - bandgap of the compound
% Tc - temperature of the cell
%
%
%
% n_i - intrinsic carrier concentration in m^3
%
% 

function [n_i] = IntrinsicCarrierConcentration(Eg,Nc,Nv,Tc)
    
    fund_consts;
    
    
    eps =Eg/(kb*Tc);
    
    n_i = sqrt(Nc*Nv)*exp(-Eg/(2*kb*Tc));

end

