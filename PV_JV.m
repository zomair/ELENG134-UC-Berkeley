% author - Zunaid Omair, zomair@eecs.berkeley.edu
% For use of the code in any work, please cite https://doi.org/10.1073/pnas.1903001116 

function[DeviceEfficiency,Voc,Jsc,FF,Vmpp,Jmpp] = PV_JV
%% fundamental constants

fund_consts;
SimulationParameters;
device_params;




%% device parameters



E = ((Eg/20):(Eg/10):(Eg*10)); % array of photon energies


% step-function absorptivity
if strcmp(Absorptivity,'Step')
    a=ones(1,length(E)); 
    a(E<Eg) =0;
    alphaGiven = 1e3/L*ones(1,length(E));
else
    Energies = h*c./Lambda;
    alphaGiven = interp1(Energies,AbsorpCoeff,E,'linear','extrap'); 
    a= FrontAbsorption(alphaGiven,L,RefBelow,Tfront); % absorptivity of the solar cell
end


%% solving for intrinsic Carrier Concentration
%n_i = IntrinsicCarrierConcentration(Eg,Nc,Nv,Tc); % intrinsic carrier concentration

Nc = 2*(mc*kb*Tc/(2*pi*(h/2/pi)^2)).^(1.5);
Nv = 2*(mv*kb*Tc/(2*pi*(h/2/pi)^2)).^(1.5);
n_i = sqrt(Nc.*Nv).*exp(-Eg/(2*kb*Tc));

 
 

%% solving for emission out of rear mirror, into the PV cell
theta = linspace(0,pi/2,1000);
if strcmp(Absorptivity,'Step')
    [arear,ENERGY,THETA] = RearMirrorEmissivity(E,theta,nr,alphaGiven,L,RefBelow); 
else
    [arear,ENERGY,THETA] = RearMirrorEmissivity(E,theta,nr,alphaGiven,L,RefBelow); 
end
rear_emission= 2*pi*arear.*2*nr^2.*ENERGY.^2.*1./(exp(ENERGY/(kb*Tc))-1).*sin(THETA).*cos(THETA)/(c^2*h^3); % rate of rear absorption in #photons/(energy*radian*surface area)
phi_rear_no_bias = trapz(E,trapz(theta,rear_emission,1));

%% calculating the current due to generation in the depletion region, for now assuming negligible
 J02 = 0;
 SRH_depletion_zero_bias = (J02/q);  % SRH inside the depletion region at zero bias


  

 %% solving for photon emission rate through the front surface 
 bc =  blackbody_photon_counts(E,Tc); 
 phi_esc_zero_bias = trapz(E,a.*bc);  % #s of photons emitted per unit area per unit time
 J01 = (q)*phi_esc_zero_bias*2;
 
 %% solving for current-voltage curve
 Vt = kb*Tc/q; % thermal voltage 
 
 
 %% Short-circuit current density
 PinModified = interp1(Esource,Pin,E,'linear','extrap');
 Jsc = q*trapz(E,IQE.*a.*PinModified./E.^2);
 
 if (J01>=Jsc)   %% Device is working as LED than PV cell
     FF=0;
     Voc = 0;
     Vmpp = 0;
     Jmpp = 0;
     DeviceEfficiency =0;
     "Bandgap is too small!"
     return;
 end

 
 
 
    if (((Rs>0) || (Rsh<1e5)) && strcmp(Material,'Lossy'))    
        [n,p] =  CarrierConcentration(n_i,Eg/q,Eg,ND,NA,Nc,Nv,Tc);
        if (n*p-n_i^2)<=0 % SRH-limited regime
            Voc =0;
            FF=0;
            Vmpp=0;
            Jmpp =0;
            DeviceEfficiency =0;
            "Your device is SRH dominated!"
            return;
        end
        
        if Vocstart<=0
            Voc =0;
            FF=0;
            Vmpp=0;
            Jmpp =0;
            DeviceEfficiency =0;
            "Your device is Auger dominated!"
            return;
        end
        PLQEStart = external_PLQE(n_i,Cn,Cp,Eg,phi_rear_no_bias,tau_SRH,SRH_depletion_zero_bias,phi_esc_zero_bias,Eg/q,ND,NA,Nc,Nv,Tc,E,alphaGiven,nr,L);
        
        Vocstart = Vt*(log(Jsc/J01)+log(PLQEStart));
        Vser =@(x) -x*Rs;
        Vdiode = @(J,V) V-Vser(J);
        PLQEfunc = @(J,V) external_PLQE(n_i,Cn,Cp,Eg,phi_rear_no_bias,tau_SRH,SRH_depletion_zero_bias,phi_esc_zero_bias,Vdiode(J,V),ND,NA,Nc,Nv,Tc,E,alphaGiven,nr,L);
        Jfunc = @(J,V) mymult((1-isinf(exp(Vdiode(J,V)/Vt))),(J-Jsc+J01/PLQEfunc(J,V).*...
                 exp(Vdiode(J,V)/Vt)+Vdiode(J,V)/Rsh))+...
                 mymult(isinf(exp(Vdiode(J,V)/Vt)),J-Jsc+Vdiode(J,V)/Rsh); % anonymous function for diode J-V, including all non-idealities
        Vocfunc = @(V)  Jsc-J01/PLQEfunc(0,V).*...
                 exp((V)/Vt)-V/Rsh;
    elseif (((Rs>0) || (Rsh<1e5)) && strcmp(Material,'Ideal'))    
        PLQEStart = 1;
        
        Vocstart = Vt*(log(Jsc/J01)+log(PLQEStart));
        Vser =@(x) -x*Rs;
        Vdiode = @(J,V) V-Vser(J);
        PLQEfunc = @(J,V) 1;
        Jfunc = @(J,V) mymult((1-isinf(exp(Vdiode(J,V)/Vt))),(J-Jsc+J01/PLQEfunc(J,V).*...
                 exp(Vdiode(J,V)/Vt)+Vdiode(J,V)/Rsh))+...
                 mymult(isinf(exp(Vdiode(J,V)/Vt)),J-Jsc+Vdiode(J,V)/Rsh); % anonymous function for diode J-V, including all non-idealities
        Vocfunc = @(V)  Jsc-J01/PLQEfunc(0,V).*...
                 exp((V)/Vt)-V/Rsh;
     elseif (((Rs==0) && (Rsh>=1e5)) && strcmp(Material,'Lossy')) 
        [n,p] =  CarrierConcentration(n_i,Eg/q,Eg,ND,NA,Nc,Nv,Tc);
        
        if (n*p-n_i^2)<=0
            Voc =0;
            FF=0;
            Vmpp=0;
            Jmpp =0;
            DeviceEfficiency =0;
            "Your device is SRH dominated!"
            return;
        end
        PLQEStart = external_PLQE(n_i,Cn,Cp,Eg,phi_rear_no_bias,tau_SRH,SRH_depletion_zero_bias,phi_esc_zero_bias,Eg/q,ND,NA,Nc,Nv,Tc,E,alphaGiven,nr,L);
        
        Vocstart = Vt*(log(Jsc/J01)+log(PLQEStart));
        if Vocstart<=0
            Voc =0;
            FF=0;
            Vmpp=0;
            Jmpp =0;
            DeviceEfficiency =0;
            "Your device is Auger dominated!"
            return;
        end
        Vser =@(x) 0;
        Vdiode = @(J,V) V-Vser(J);
        PLQEfunc = @(J,V) external_PLQE(n_i,Cn,Cp,Eg,phi_rear_no_bias,tau_SRH,SRH_depletion_zero_bias,phi_esc_zero_bias,Vdiode(J,V),ND,NA,Nc,Nv,Tc,E,alphaGiven,nr,L);
        Jfunc = @(J,V) mymult((1-isinf(exp(Vdiode(J,V)/Vt))),(J-Jsc+J01/PLQEfunc(J,V).*...
                 exp(Vdiode(J,V)/Vt)+Vdiode(J,V)/Rsh))+...
                 mymult(isinf(exp(Vdiode(J,V)/Vt)),J-Jsc+Vdiode(J,V)/Rsh); % anonymous function for diode J-V, including all non-idealities
        Vocfunc = @(V)  Jsc-J01/PLQEfunc(0,V).*...
                 exp((V)/Vt)-V/Rsh;
    else
        PLQEStart = 1;
        Vocstart = Vt*(log(Jsc/J01)+log(PLQEStart));
        Jfunc = @(J,V) J-(Jsc-(J01.*...
               exp(V/Vt))); % anonymous function for diode J-V, including all non-idealities
         
         Vocfunc = @(V)  Jsc-(J01.*...
                 exp((V)/Vt));
    end
        
        
        Voc = fzero(Vocfunc,Vocstart);
        if ((Voc<=0)|| isnan(Voc))
            Voc =0;
            FF=0;
            Vmpp=0;
            Jmpp =0;
            DeviceEfficiency =0;
            "Your device is Auger dominated!"
            return;
        end
        MAX =0;
        RISE = 0;
        FALL =0;
        Vnew = Voc*0.5;
        
        
        
        
        J0 = Jsc*3/4;
        k=0;
        while(~MAX)
            
            J1 = fzero(@(J) Jfunc(J,Vnew),J0);
            J2 = fzero(@(J) Jfunc(J,Vnew+Vdel),J1);
            J3 = fzero(@(J) Jfunc(J,Vnew+Vdel*3),J2);
            J4 = fzero(@(J) Jfunc(J,Vnew+Vdel*4),J3);
            P1 = J1*Vnew;
            P2 = J2*(Vnew+Vdel);
            P3 = J3*(Vnew+Vdel*3);
            P4 = J4*(Vnew+Vdel*4);

            DoubleSlope=(P2-P1)/(P4-P3);
            Slope =P2-P1;
            if (DoubleSlope>0) && (Slope>0)
                MAX =0;
                RISE =1;
                FALL =0;
            elseif (DoubleSlope>0) && (Slope<0)
                MAX =0;
                RISE =0;
                FALL =1;
            else
                MAX =1;
                RISE =0;
                FALL =0;

            end
            
            
            if (RISE)
                Vnew = Vnew+(Voc-Vnew)/2;
                J0 = J3;
            elseif(FALL)
                Vnew = Vnew-(Voc-Vnew)/2;
            else
                Vmpp = Vnew;
                Jmpp = J1;
            end
            k = k+1;
           
        end
        FF = Vmpp*Jmpp/(Voc*Jsc);
            
        
    %[n,p] = CarrierConcentration(n_i,Vop,Eg,ND,NA,Nc,Nv,Tc);
    %PLQE = PLQEfunc(Jmpp,Vmpp); % calculating the external PLQE

    %[Nonradiative_loss,Mirror_loss,Radiative_escape,B] = all_loss(n_i,n,p,phi_rear_no_bias,Cn,Cp,tau_SRH,SRH_depletion_zero_bias,phi_esc_zero_bias,Vop,Tc,E,alpha,nr,L);
    %InternalPLQE = B.*n.*p./(B.*n.*p+Nonradiative_loss/L);
    %% calculating efficiency
    DeviceEfficiency = Vmpp*Jmpp/trapz(Esource,Pin./Esource); % maximum efficiency at a particular emitter temperature
end
 