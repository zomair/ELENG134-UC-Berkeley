

function [arear,ENERGY,THETA] = RearMirrorEmissivity(E,theta,nr,alpha,L,RefBelow)
    

    fund_consts;
   
    
    
    
    thetac = asin(1/nr); % calculating the critical angle
    
    arear = zeros(length(theta),length(E));
    
    [ENERGY,THETA] = meshgrid(E,theta);
    [ALPHA,~]=meshgrid(alpha,theta);
    
    Leff = L./cos(THETA); % effective thickness of active layer
    
    % for rays below critical angle
    arear(theta<thetac,:) = (1-RefBelow)*(1-exp(-ALPHA(theta<thetac,:).*Leff(theta<thetac,:)));
    % for rays above critical angle
    arear(theta>=thetac,:) = (1-RefBelow)*(1-exp(-2*ALPHA(theta>=thetac,:).*Leff(theta>=thetac,:)))./(1-RefBelow*exp(-2*ALPHA(theta>=thetac,:).*Leff(theta>=thetac,:)));
    
    arear(isnan(arear)) = (1-exp(-2*ALPHA(isnan(arear)).*Leff(isnan(arear))));
      
              
              
      
    
    
    
end

