% it solves the carrier concentration inside a doped semiconductor under
% applied bias, using charge neutrality
%
%
% Input-
% n_i - intrinsic carrier concentration of the semiconductor
% V - applied bias
% Eg_InGaAs - band gap of the material
%
% Output-
% n- electron concentration
% p - hole concentration




function [n,p] = CarrierConcentration(n_i,V,Eg,ND,NA,Nc,Nv,Tc)
    
    
    %% fundamental constants
    fund_consts;
   
    %% solving for n
    
    
    eps = (Eg-q*V)/(kb*Tc); % dummy variable
    eff_N = (ND-NA); % effective doping density
    
    %% calculating the starting point for non-linear solver
    if (eff_N>0)
        x0 = -(Eg/2-kb*Tc*log(eff_N/n_i)); % x would be the EF-EC
        
    elseif (eff_N<0)
        x0 = -(Eg/2+kb*Tc*log(eff_N/n_i));
    else
        x0 = -Eg/2;
    end
    
    
    fun = @(x) (Nc)*fermi(0.5,x)-(Nv)*fermi(0.5,-x-eps)-eff_N;
    
    xact = fzero(fun,x0+0.01); % dummy variable, actual value of x
    
    n = (Nc)*fermi(0.5,xact);
    
    p = (Nv)*fermi(0.5,xact-eps);
        
end

