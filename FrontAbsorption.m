function[a]=FrontAbsorption(alpha,L,RefBelow,Tfront)

    % calculates the angle-independent front absorptivity of a
    % semiconductor sample. alpha is the is energy dependent absorbance,
    % RefBelow is the reflectivity of the rear mirror 
    % Tfront is the frontsurface transmissivity
    
    fund_consts; % loading the values of the fundamental constants
    
 
    
   % the formula is based on a derivation I did, look in the notes for 
   % Spring 2018
   
   r = exp(-alpha.*L).*RefBelow.*exp(-alpha.*L).*(1-Tfront); % this is the 
   % ratio of the terms that are summed together in the geometric sum
   
   a  = Tfront.*(1-exp(-alpha.*L))./(1-r)... % downward rays
       + Tfront.*exp(-alpha.*L).*RefBelow.*(1-exp(-alpha.*L))./(1-r);
                                         % upward rays       
    
   
    
end