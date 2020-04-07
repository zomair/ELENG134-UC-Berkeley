    %% fundamental parameter
    fund_consts;
    
    IQE =1; % internal quantum efficiency
    %% Circuit parameter for the solar cell, in units of Ohm.m2
    RsContact = 0; % series resistance
    Rsh = 1e6; % shunt resistance
    
    
    %% environmental parameters
    Tc =300; % temperature of the cell
    
    %% doping density
   
    ND = 0; % donor doping density 
    NA = 0; % acceptor doping density
    
    %% Cell geometrical parameter
    L = 1e-6; % thickness of cell
    
    %% Material parameters
    
    Material ='Lossy'; %either Lossy or Ideal
    if strcmp(Material,'Lossy')
        tau_SRH = 1e-6; % SRH lifetime in units of Seconds
        Cn = 1.1e-30*1e-12; % Electron Auger recombination coefficient 
        Cp = 0.3*1e-30*1e-12;% Hole Auger recombination coefficient 
        RefBelow = 1;  % reflectivity of the back-mirror of the cell
        Mun = 1e3*1e-4; % electron mobility in m^2/(V.sec)
        Mup = 500*1e-4;% hole mobility in m^2/(V.sec)
    else
        RefBelow = 1;  % reflectivity of the back-mirror of the cell
    end
    nr = 3.5; % refractive index, assumed to be same as GaAs
    
    
    %% Absorption Coefficients 
    Absorptivity = 'Dispersive'; % can be either Step or Dispersive
    if strcmp(Absorptivity,'Dispersive')
        
       AbsorpCoeff = ; %% provide the material absorption coefficient
       % here, in units of 1/m
       Lambda = ; %% provide the wavelengths (in m) at which the
       % absorption coefficient was measured, the array length should be 
       %the same as the absorption coefficient array
       Eg = 1.124*q;
    else
        Eg = 1.31*q; % bandgap
    
    end
    
    Tfront =1;   % Transmissivity of the front surface of the cell, 
       % unitless
    
    %% effective mass calculation
    mc = 1.06*m0; % electron DOS effective mass
    mv = 0.59*m0; % hole DOS effective mass
    
    %% incident spectrum
    SourceType = 'Spectrum'; % can be eithe Blackbody expression or an 
    % tabular spectrum, like AM 1.5 in W/m^2
    if strcmp(SourceType,'Spectrum')
        Pin =  ; %% provide the material incident spectrum here
       % , in units of W/m2
        LambdaSource = ; %% provide the wavelengths (in m) at
       % which the incident spectrum  was measured, the array length should
       % be the same as the absorption coefficient array
       
       Esource = h*c./LambdaSource;
    else
        Emissivity = 1;
        GeometricViewFactor = 2.18e-5*Emissivity; % View factor of the Sun, 
        % from the solar cell
        Ts = 6000;
        func = @(x) 2*pi*x.^3./(c^2*h^3*(exp(x/(kb*Ts))-1));
        Esource = linspace(1e-3,10,1e3)*q; % photon energy array
        Pin = func(Esource)*GeometricViewFactor.*Esource; %incident power 
        % in watts/m^2
        
    end
  
    
