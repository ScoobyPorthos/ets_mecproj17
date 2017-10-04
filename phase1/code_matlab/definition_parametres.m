%% REU 02/10
% Définition des paramètres de notre avion

clear all
close all
clc 

%% ON DEFINIT LA GEOMETRIE
% On moyenne sur les valeurs des trois avions semblables

A = 9.3;

%% ON DEFINIT LE PAYLOAD
Wpayload = 70*(180+40)+3*180; %pour l'équipage on ne compte que les bagages cabine

%% ON DEFINIT LE RANGE
range = 5000;

%% ON DEFINIT LES MOTEURS
% Nombre de moteurs : 2 (étude historique)
TSFC = 0.5; 

%% ON DEFINIT LES PARAMETRES PAR DEFAUT
M_cruise = 0.85;
H_cruise = 40000; %Altitude de croisière usuelle
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

%% CALCUL CHARGE ALAIRE LD
WS_L = Wlanding/S;

%% ON DETERMINE LA POUSSEE
T_Wto = 0.35; % RATIO POUSSEE POIDS
T = Wto*T_Wto;% Cours 3, valeurs typiques longues distances

%% AERODYNAMIQUE/PERFORMANCE
% Finesse max
Cd0 = 0.015;
%F_max = finesse(M_cruise,A);
F_max = sqrt(1/(4*0.015*k_oswald(9.3,0.8))); %par methode d'oswald 


% Distance d'atterissage fixée 
SL = 4600; % Optimale : 4600 ft, Réaliste : 5900 ft

% Calcul du CLmax,L = CLmax
LP = (SL - 400) / 118;
CLmax = WS_L / LP

% Calcul du CLmax,TO
CLmaxTO = 0.8 * CLmax

% Calcul de la distance de décollage
TOP = WS_TO * (1/CLmaxTO) * (1/T_Wto);
Sto = 20.9*TOP + 87*sqrt(TOP*T_Wto)


