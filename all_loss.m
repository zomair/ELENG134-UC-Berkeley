function[phi_nr,phi_rear,phi_r,B] = all_loss(n_i,n,p,phi_rear_no_bias,Cn,Cp,tau_SRH,SRH_depletion_zero_bias,phi_r_zero_bias,V,Tc,E,alpha,nr,L)
        

    fund_consts;
    
 
   
    B = SVR(V,E,n,p,alpha,nr,Tc); % bimolecular recombination coefficient
    SRH = (SRH_calc(n,p,n_i,tau_SRH))*L;    
    Auger =(Auger_calc(n,p,n_i,Cn,Cp))*L;
    phi_nr =SRH+Auger;
    
    
    phi_rear = phi_rear_no_bias*exp(q*V/(kb*Tc));

   % SRH_depletion = SRH_depletion_zero_bias.*exp(q*V/(2*kb*Tc));
    phi_r = phi_r_zero_bias*exp(q*V/(kb*Tc));
    
    
   
end