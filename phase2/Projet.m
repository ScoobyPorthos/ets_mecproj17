%== Mission
    PAX = 70;   % Passager number.
    Crew = 6;   % Crew number.
    Wbag = 100;
    Wpeople = 160;
    Wpayload = PAX*(Wpeople+Wbag)+Crew*(Wpeople+10);
    Range = 6000;   % Range in (nautic mille)
    fprintf('--- Paramètre de Mission ---\n');
    fprintf('| * PAX : %f               \n',PAX);
    fprintf('| * Equipage : %f          \n',Crew);
    fprintf('| * Poids (lb)                  \n');
    fprintf('|   + Poids Bagage : %f	\n',Wbag);
    fprintf('|   + Poids passager : %f	\n',Wpeople);
    fprintf('|   = Poids Payload : %f	\n',Wpayload);
    fprintf('| * Range (NM): %f             \n',Range);

%== Choix Designer   
    M_cruise = 0.81;    % Max Speed
    H_cruise = 35000;   %Altitude de vol moyenne initiale (sera modifiée lors de l'optimisaiton des paramètres)
    A = 11 ;
    Charge_Ailaire=120;  %Charge Ailaire en Croisière (lb/ft^2)
    Pol =  importdata('xf-naca4412-il-1000000-n5.txt');
    
    Thrust_tot = 46000;
    TSFC = 0.5;
    C = TSFC;
    CLmaxTo=2.5;
    
    tx_montee = 0.03;   %train d'atterissage rentré, un moteur en moins (%)
    gamma_montee = atan(tx_montee);
    CD0 = 0.021;        %Coef de trainée à portance nulle
    f = 1/sqrt(4*1/(pi*A*0.8)*CD0);          %finesse max    
    F_max = f;
    T_loiter = 30;      % Waiting Time in (min)
    Fuel_res=0.05;       % Fraction d'essence avant l'atterrisage
    Fuel_trap=0.01;      % Fraction d'essence dans les conduites

    fprintf('\n--- Choix Designer ---\n');
    fprintf('| * Mach cruise : %f\n',M_cruise);
    fprintf('| * H cruise (ft) - Initial Value (will be optimized): %f \n',H_cruise);
    fprintf('| * Aspect Ration : %f \n',A);
    fprintf('| * Charge à l air en croissière (lb/ft^2): %f\n',Charge_Ailaire);
    fprintf('| * Poussée totale (lb): %f\n',Thrust_tot);
    fprintf('| * Consommation Spécifique (lb fuel / h / lb pousse): %f\n',TSFC);
    fprintf('| * Pente de Montée : %f (train d atterissage rentré, un moteur en moins)\n',tx_montee);
    fprintf('| * CD0: %f\n',CD0);
    fprintf('| * Temps d attente (min): %f\n',T_loiter);
    fprintf('| * Fraction d essence avant l atterrisage (Wres/Wfuel): %f\n',Fuel_res);
    fprintf('| * Fraction d essence dans les conduites (Wtrap/Wfuel): %f\n',Fuel_trap);

    k=1/(pi()*A*0.8);
    
%==Calcul Hcruise + Poids pour la mission considérée

    fcruise = 1 / exp(Range*TSFC*6080/(vitesse(M_cruise,H_cruise)*F_max*3600));
    fl=1/exp(T_loiter*TSFC/(F_max*60));
    fclimb = 1 -0.04*M_cruise;
    fdec = 0.975;
    fland = 0.975;

    fprintf('\n--- Optimisation de l Altitude et Calcul du Poids --- \n');
   [ Wto, Wfuel, Wempty ] = itertow('jet-transport',M_cruise, H_cruise, A, TSFC, T_loiter, Fuel_res, Fuel_trap, Wpayload, CD0, Range);
   
   Wlanding = Wempty + Wfuel*(Fuel_res+Fuel_trap)+Wpayload;
   %Wmoy = (Wlanding+Wto)/2;
   Wmoy = Wto*fdec*fclimb;
   
   S=Wmoy/Charge_Ailaire;                       %Charge à l'aire en milieu de mission
   [T, a, P, rho] = atmosisa(H_cruise/3.28);    %masse volumique au Hcruise
   rho = rho*0.06854/3.28^3;                    %(slug/ft^3)
   
   Vmoy = sqrt(2/rho*Wmoy/S)*(3*k/CD0)^0.25;    %vitesse moyenne lors du vol (ft/s)
   Vmach=M_cruise*sqrt(1.4*1716.5*T*9/5);       %vitesse désirée pour le Mach du choix de designer (ft/s)
   
while Vmoy/Vmach > 1.02;                         %While qui décroit l'altitude moyenne pour rapprocher la vitesse moyenne du vol au mach de designer
    H_cruise = H_cruise - 20;
    [ Wto, Wfuel, Wempty ] = itertow('jet-transport',M_cruise, H_cruise, A, TSFC, T_loiter, Fuel_res, Fuel_trap, Wpayload,CD0, Range);
    Wlanding = Wempty + Wfuel*(Fuel_res+Fuel_trap)+Wpayload;
    %Wmoy = (Wlanding+Wto)/2;
    Wmoy = Wto*fdec*fclimb;
    S=Wmoy/Charge_Ailaire;
    [T, a, P, rho] = atmosisa(H_cruise/3.28);
    rho = rho*0.06854/3.28^3;
    Vmoy = sqrt(2/rho*Wmoy/S)*(3*k/CD0)^0.25;
    Vmach=M_cruise*sqrt(1.4*1716.5*T*9/5);
    M_real = Vmoy/sqrt(1.4*1716.5*T*9/5);
end
    fprintf('| * Mach real : %f\n',M_real);
    fprintf('| * H real (ft): %f \n',H_cruise);
    fprintf('| * Surface à l air (ft^2): %f\n',S);
    fprintf('| * Envergure (ft): %f\n',sqrt(A*S));
    fprintf('| * Charge à l aire au décollage (lb/ft^2): %f\n',Wto/S);
    fprintf('| * Poids (lb)                  \n');
    fprintf('|   + Poids Vide : %f	\n',Wempty);
    fprintf('|   + Poids Fuel : %f	\n',Wfuel);
    fprintf('|   = Poids Takeoff : %f	\n',Wto);

%== Aerodynamique 
WS_L = Wlanding/S; % Charge à l'aire à l'attérissage
WS_TO = Wto/S; %Charge à l'aire au décollage
SL = 4400; %% Distance d'atterissage fixée Optimale : 4600 ft, Réaliste : 5900 ft
CLmax = WS_L / ((SL - 400) / 118);  % Calcul du CLmax,L = CLmax

% Calcul du CLmax,TO
CLmaxTO = 0.8 * CLmax;

% Calcul de la distance de decollage
T_Wto = Thrust_tot/Wto;
Sto = 20.9*(WS_TO * (1/CLmaxTO) * (1/T_Wto)) + 87*sqrt((WS_TO * (1/CLmaxTO) * (1/T_Wto))*T_Wto);

% Calcul de la vitesse de decrochage
Vs = sqrt((2*Wto)/(density(0)*S*CLmax));

% Calcul de la vitesse de decollage
Vto = 1.1*Vs;

ratio=(Thrust_tot/(2*Wto))/(tx_montee+sqrt(CD0*k));% verif puissance avec panne de 1 moteur

    fprintf('\n--- Performance aerodynamique --- \n');
    fprintf('| * Finesse Max : %f\n',F_max);
    fprintf('| * CL_max (CL_landing): %f \n',CLmax);
    fprintf('| * CL_max (CL_takeoff): %f \n',CLmaxTO);
    fprintf('| * Distance de décollage (ft): %f\n',Sto);
    fprintf('| * Distance d atterissage (ft): %f\n',SL);
    fprintf('| * Vitesse de décrochage (ft/s): %f\n',Vs);
    fprintf('| * Vitesse de décollage (ft/s): %f\n',Vto);
    
if ratio<1;
    fprintf('| = l avion n a pas suffisament de puissance pour décoler \n');
else
    fprintf('| = l avion a suffisament de puissance pour décoler \n');
end 

%== Charge à l'aire
q = .5*density(0)*Vto^2;
T = q*S*(CD0+k*CLmaxTO^2)+Wto*sin(atan(tx_montee));
T_Wto = T/Wto;
WS_climb_int = (T_Wto - tx_montee)^2-4*CD0*cos(gamma_montee)^2*k;
WS_climb = q/(2*cos(gamma_montee)^2*k)*((T_Wto - sin(atan(tx_montee)))+sqrt(WS_climb_int));    

fprintf('\n--- Charge à l aire ramené à Wto --- \n');
fprintf('| * W/S takeoff (lb/ft^2): %f\n',WS_TO);
fprintf('| * W/S Climb (lb/ft^2): %f\n',WS_climb/(fdec*fclimb));
fprintf('| * W/S Croissière (lb/ft^2): %f\n',Charge_Ailaire/(fdec*fclimb));
fprintf('| * W/S Landing (lb/ft^2): %f\n',WS_L/(fdec*fclimb*fcruise*fl));





