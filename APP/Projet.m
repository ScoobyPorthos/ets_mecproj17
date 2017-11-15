%== Mission
    PAX = 70;   % Passager number.
    Crew = 6;   % Crew number.
    Wbag = 100;
    Wpeople = 160;
    Wpayload = PAX*(Wpeople+Wbag)+Crew*(Wpeople+10);
    Range = 6000;   % Range in (nautic mille)
  

%== Choix Designer   
    M_cruise = 0.81;    % Max Speed
    H_cruise = 35000;   %Altitude de vol moyenne initiale (sera modifi�e lors de l'optimisaiton des param�tres)
    A = 11 ;
    Charge_Ailaire=120;  %Charge Ailaire en Croisi�re (lb/ft^2)
    
    Thrust_tot = 46000;
    TSFC = 0.5;
    C = TSFC;
    CLmaxTo=2.5;
    
    tx_montee = 0.03;   %train d'atterissage rentr�, un moteur en moins (%)
    CD0 = 0.021;        %Coef de train�e � portance nulle
    f = 1/sqrt(4*1/(pi*A*0.8)*CD0);          %finesse max    
    F_max = f; 
    T_loiter = 30;      % Waiting Time in (min)
    Fuel_res=0.05;       % Fraction d'essence avant l'atterrisage
    Fuel_trap=0.01;     % Fraction d'essence dans les conduites
    k=1/(pi()*A*0.8);
    
%==Calcul Hcruise + Poids pour la mission consid�r�e

    fcruise = 1 / exp(Range*TSFC*6080/(vitesse(M_cruise,H_cruise)*F_max*3600));
    fl=1/exp(T_loiter*TSFC/(F_max*60));
    fclimb = 1 -0.04*M_cruise;
    fdec = 0.975;
    fland = 0.975;

%== Aerodynamique 
    SL = 4400; %% Distance d'atterissage fix�e Optimale : 4600 ft, R�aliste : 5900 ft

    AngflecheLe=30*pi/180;   %angle de fl�che historique r�duisant le nombre de Mach effectif (rad)
    EffAile=0.17;    %effilement minimisant la train�e induite pour une aile trap�zo�dale
    
    Q_aile = 1; %Aile basse avec cong� de raccordement


%== Aile
Pol = importdata('xf-naca4412-il-1000000-n5.txt');
%mu =@(T)((8.8848e-15*(T^3)-3.2398e-11*(T^2)+6.2657e-8*T+2.3543e-6)/9.81)*(1/3.28)^2*2.2048;%(lb.sec/ft^2)

Angle_fleche_epmax=AngflecheLe;  %Solidworks ?
epmax = 12/100; %ratio d'�paisseur max du profil
xcm = 40/100;   %position sur la corde du point d'�paisseur max

%== Fuslage
l= 51.81756*3.28;% (ft) choix de designer suite au dessin
Aside=4.7*3.28; %(ft)
Atop= 4.5*3.28; %(ft)
k_surface = 2.08e-5; % (ft) etat de surface / rugosite
Q_fuselage = 1;

%== TRain�e d'onde
Ma_DD_Cl0 = 0.8085; % apr�s lecture graphique du diagrame p36@cours5
coeff_dC_d_M = [1 3 1.1];


%== Empengage

C_VT = 0.09; % Valeur du cours 6
lvt = 2/4*l;%(ft) a changer avec les valeurs du cad
AR_VT = 5; % Cours 6, p28 type autre
effilement_vt = 0.6;
Angle_fleche_VT  = AngflecheLe; % A modifier
Angle_tcmax_VT = 0.47; % A Modifier !
Q_vt = 1.05;
xcm_vt= 0.25; %NACA 0014
tc_vt= 0.14; %NACA 0014

C_HT = 1.00; % Valeur du cours 6
lht = 2/4*l;%(ft) idem
AR_HT = 5; % Cours 6, p28 type autre
effilement_ht = 0.6;
Angle_fleche_HT  = AngflecheLe; % A modifier
Angle_tcmax_HT = 0.47; % A Modifier !
Q_ht = 1.05;
xcm_ht= 0.25; %NACA 0014
tc_ht= 0.14; %NACA 0014
