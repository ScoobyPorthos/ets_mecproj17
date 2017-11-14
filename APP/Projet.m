%== Mission
    PAX = 70;   % Passager number.
    Crew = 6;   % Crew number.
    Wbag = 100;
    Wpeople = 160;
    Wpayload = PAX*(Wpeople+Wbag)+Crew*(Wpeople+10);
    Range = 6000;   % Range in (nautic mille)
  

%== Choix Designer   
    M_cruise = 0.81;    % Max Speed
    H_cruise = 35000;   %Altitude de vol moyenne initiale (sera modifiée lors de l'optimisaiton des paramètres)
    A = 11 ;
    Charge_Ailaire=120;  %Charge Ailaire en Croisière (lb/ft^2)
    
    Thrust_tot = 46000;
    TSFC = 0.5;
    C = TSFC;
    CLmaxTo=2.5;
    
    tx_montee = 0.03;   %train d'atterissage rentré, un moteur en moins (%)
    CD0 = 0.021;        %Coef de trainée à portance nulle
    f = 1/sqrt(4*1/(pi*A*0.8)*CD0);          %finesse max    
    F_max = f; 
    T_loiter = 30;      % Waiting Time in (min)
    Fuel_res=0.05;       % Fraction d'essence avant l'atterrisage
    Fuel_trap=0.01;     % Fraction d'essence dans les conduites
    k=1/(pi()*A*0.8);
    
%==Calcul Hcruise + Poids pour la mission considérée

    fcruise = 1 / exp(Range*TSFC*6080/(vitesse(M_cruise,H_cruise)*F_max*3600));
    fl=1/exp(T_loiter*TSFC/(F_max*60));
    fclimb = 1 -0.04*M_cruise;
    fdec = 0.975;
    fland = 0.975;

%== Aerodynamique 
    SL = 4400; %% Distance d'atterissage fixée Optimale : 4600 ft, Réaliste : 5900 ft

    AngflecheLe=30*pi/180;   %angle de flèche historique réduisant le nombre de Mach effectif (rad)
    EffAile=0.17;    %effilement minimisant la trainée induite pour une aile trapézoïdale
    
    Q_aile = 1; %Aile basse avec congé de raccordement


%== Aile
Pol = importdata('xf-naca4412-il-1000000-n5.txt');
%mu =@(T)((8.8848e-15*(T^3)-3.2398e-11*(T^2)+6.2657e-8*T+2.3543e-6)/9.81)*(1/3.28)^2*2.2048;%(lb.sec/ft^2)

Angle_fleche_epmax=AngflecheLe;  %Solidworks ?
epmax = 12/100; %ratio d'épaisseur max du profil
xcm = 40/100;   %position sur la corde du point d'épaisseur max

%== Fuslage
l= 51.81756*3.28;% (ft) choix de designer suite au dessin
Aside=4.7*3.28; %(ft)
Atop= 4.5*3.28; %(ft)
k_surface = 2.08e-5; % (ft) etat de surface / rugosite
Q_fuselage = 1;


