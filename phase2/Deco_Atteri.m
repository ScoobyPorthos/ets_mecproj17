Aero;

%% Estimation détaillée de la distance de décollage

% Distance de parcourt au sol : sG

g = 32.2;
Mu_decollage = 0.05;                %cas pessimiste Asphate Mouillée
f1 = Thrust_tot/Wto - Mu_decollage;
rho = 0.0023769;
C_lg = 0.1;                                        % Cours 8 Diapo 16
dCD0_flap = 0.05;                                  % Cours 8 Diapo 17 => Plain 30° => A MODIFIER P-E !
A_lg = ((0.675*0.19)*2+(1*0.355)*4)*3.28^2;        % Aire frontale de 4 + 2 pneux de Boeing 737
dCD0_lg = 1.4*(A_lg/S);                            % Cours 8 Diapo 17 => Boggie => A MODIFIER P-E !
f2 = (rho/(2*(Wto/S)))*(Mu_decollage*C_lg - CD0_avion - k*C_lg^2 - dCD0_flap - dCD0_lg)

sG = (1/(2*g*f2))*log(1 + (f2*Vto^2)/f1)

fprintf('| * Distance parcourue au sol : %f               \n',sG);

% Distance pendant la rotation : sR

sR = 2.5*Vto;                                         % avion plus petit que les très gros avions...
fprintf('| * Distance de Rotation : %f               \n',sR);

% Distance pendant la transition : sTR

angle_montee = deg2rad(3); % 3° ??
R = (1.15*Vs)^2/(g*(1.19-1));

sTR = R*sin(angle_montee);
fprintf('| * Distance de Transition : %f               \n',sTR);

% Distance pendant la montée : sCL

hTR = R*(1 - cos(angle_montee));
Hobstacle = 35; % Cours 8 Diapo 27

sCL = (Hobstacle - hTR)/tan(angle_montee);
fprintf('| * Distance de Montee : %f               \n',sCL);

% Distance totale de décollage
sTO = sG + sR + sTR + sCL;
fprintf('| * Distance de Decollage : %f               \n',sTO);


%% Estimation détaillée de la distance d'atterrissage

% Distance pendant la descente

angle_approche = deg2rad(-2) % A CALCULER EN DETAIL !
Vtr = 1.23*Vs; % Cours 8 Diapo 32
n = 1.36; % Cours 8 Diapo 32
R = Vtr^2/((n-1)*g);
hTR = R*(1 - cos(angle_approche));

sA = (hTR - 50)/tan(angle_approche);
fprintf('| * Distance de Descente : %f               \n',sA);

% Distance pendant la transition

sTR = -R*sin(angle_approche);
fprintf('| * Distance de Transition : %f               \n',sTR);

% Distance pendant la roue libre

Vtd = 1.15*Vs;
sFR = 3*Vtd;
fprintf('| * Distance de Roue libre : %f               \n',sFR);

% Distance de freinage

Trev = 0; % A MODIFIER P-E
%Wtd = 0.5*rho*Vtd^2*S*CLmax;
Wtd = Wlanding;
Mu_atterrissage = 0.15; %cas pessimiste Asphate Mouillée avec freins
f1 = Trev/Wtd + Mu_atterrissage;
f2 = (rho/(2*(Wtd/S)))*(-Mu_atterrissage*C_lg + CD0_avion + k*C_lg^2 + dCD0_flap + dCD0_lg);

sB = (1/(2*g*f2))*log(1 + (f2*Vtd^2)/f1);
fprintf('| * Distance de Freinage : %f               \n',sB);

% Distance totale d'atterissage

sL = 1.6*(sA + sTR + sFR + sB);
fprintf('| * Distance d''Atterrissage : %f               \n',sL);
