function[eta_ext] = external_PLQE(n_i,Cn,Cp,Eg,phi_rear_no_bias,tau_SRH,SRH_depletion_zero_bias,phi_r_zero_bias,V,ND,NA,Nc,Nv,Tc,E,alpha,nr,L)
        

    fund_consts;
   
    
    [n,p] =  CarrierConcentration(n_i,V,Eg,ND,NA,Nc,Nv,Tc);
   
    %B = SVR(V,E,n,p,alpha,nr,Tc); % bimolecular recombination coefficient
    SRH = (SRH_calc(n,p,n_i,tau_SRH));
    Auger =(Auger_calc(n,p,n_i,Cn,Cp));
    phi_nr =(SRH+Auger)*L;
    
    
    phi_rear = phi_rear_no_bias*exp(q*V/(kb*Tc));

    SRH_depletion = SRH_depletion_zero_bias.*exp(q*V/(2*kb*Tc));
    phi_r = phi_r_zero_bias*exp(q*V/(kb*Tc));
    
    
    eta_ext = phi_r./(phi_r+phi_nr+phi_rear+SRH_depletion);
end