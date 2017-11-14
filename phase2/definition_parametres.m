%% REU 02/10
% D?finition des param?tres de notre avion

clear all
close all
clc 

%% ON DEFINIT LA GEOMETRIE
% 
A_emp = [9.300 9.500 9.423];
A = mean(A_emp);

longueur_totale_emp = [138.5 123.3 110.2];
D_emp = [13.32 12.14 11.61];
longueur_totale = mean(longueur_totale_emp);
D = mean(D_emp);

%% ON DEFINIT LE PAYLOAD
poids_passager = 180;
poids_bagage = 60;
Wpayload = 70*(poids_passager+poids_bagage)+3*poids_passager; %pour l'?quipage on ne compte que les bagages cabine

%% ON DEFINIT LE RANGE
range = 5000;

%% ON DEFINIT LES MOTEURS
% Nombre de moteurs : 2 (?tude historique)
TSFC = 0.5; 

%% ON DEFINIT LES PARAMETRES PAR DEFAUT
M_cruise = 0.85;
H_cruise = 40000; %Altitude de croisi?re usuelle
T_loiter=30; %30min d'attente
Wres=0.05; % Fraction d'essence avant l'atterrisage
Wtrap=0.01; % Fraction d'essence dans les conduites


%% ON DETERMINE LE POIDS
[ Wto, Wfuel, Wempty ] = itertow( 'jet-transport', M_cruise, H_cruise, ...
A, TSFC, T_loiter, Wres, Wtrap, Wpayload, range );

Wlanding = Wto-Wfuel;

%% CALCUL CHARGE ALAIRE TO
%WS_TO = Wto/S;
WS_TO = 125;
S= Wto/WS_TO;

%% ON DEFINIT b
b = sqrt(A*S);

%% CALCUL CHARGE ALAIRE LD
WS_L = Wlanding/S;

%% ON DETERMINE LA POUSSEE
T = Wto*0.35;% Cours 3, valeurs typiques longues distances

%% RATIO POUSSEE POIDS
T_Wto = T/Wto;



%% AERODYNAMIQUE/PERFORMANCE
% Finesse max
F_max = finesse(M_cruise,A)

% Distance d'atterissage fix?e 
SL = 5300; % Optimale : 4600 ft, R?aliste : 5900 ft

% Calcul du CLmax,L = CLmax
LP = (SL - 400) / 118;
CLmax = WS_L / LP

% Calcul du CLmax,TO
CLmaxTO = 0.8 * CLmax

% Calcul de la distance de decollage
TOP = WS_TO * (1/CLmaxTO) * (1/T_Wto);
Sto = 20.9*TOP + 87*sqrt(TOP*T_Wto)

% Calcul de la vitesse de decrochage
p = 0.0023769;
Vs = sqrt((2*Wto)/(p*S*CLmax))

% Calcul de la vitesse de decollage
Vto = 1.1*Vs