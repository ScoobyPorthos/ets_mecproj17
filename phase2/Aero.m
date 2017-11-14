Projet;
%% Polaire du profil 4412
fprintf('\n--- Profil 4412 ---\n');
Pol =  importdata('xf-naca4412-il-1000000-n5.txt');
i=1:size(Pol.data);
plot(Pol.data(:,1),Pol.data(:,2))%,profil(:,1)/100*corde,-profil(:,2)/100*corde);

[m i_fin_max] = max(Pol.data(:,2)./Pol.data(:,3));
incidence=Pol.data(:,1);
incidencefmax=(incidence(i_fin_max));
Cl=Pol.data(:,2);

test = logical(incidence>-10).*logical(incidence<5);

[xData, yData] = prepareCurveData( incidence(logical(test))*pi/180, Cl(logical(test)));
incidence=incidence*pi/180;
% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares');

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
p = coeffvalues(fitresult);
a0 = p(1);
alpha0 = -p(2)/p(1); %rad
fprintf('| * cl = %f [rad^-1] * (Alpha - (%f))\n',a0,alpha0);
%% Coefficient de portance 3D
fprintf('\n--- Portance de l aile (H_cruise)---\n');
mu =@(T)((8.8848e-15*(T^3)-3.2398e-11*(T^2)+6.2657e-8*T+2.3543e-6)/9.81)*(1/3.28)^2*2.2048;%(lb.sec/ft^2)
T = tempatmstd(H_cruise);

Angle_fleche_Le=30*2*pi()/360;   %angle de flèche historique réduisant le nombre de Mach effectif (rad)
Effilement=0.17;    %effilement minimisant la trainée induite pour une aile trapézoïdale
b=sqrt(S*A);        %envergure
Cr = 2*b/(A*(1+Effilement));    %corde à la base de l'aile
Ct = Effilement*Cr;             %corde en bout d'aile
Cmoy = 2*Cr/3*(1+Effilement+Effilement^2)/(1+Effilement);

Angle_fleche_c4 = atan(tan(Angle_fleche_Le)-Cr/(2*b)*(1-Effilement));  %angle de flèche au quart de la corde (rad)
Angle_fleche_c2 = atan(tan(Angle_fleche_Le)-Cr/b*(1-Effilement));  %angle de flèche au mileu de la corde (rad)

fprintf('| * Géonemtrie\n');
fprintf('|   + Envergure : %f\n',b);
fprintf('|   + Croot (ft): %f\n',Cr);
fprintf('|   + Ctip (ft): %f\n',Ct);
fprintf('|   + Effilement : %f\n',Effilement);
fprintf('|   + Angle de flèche : %f [deg] (historique réduisant le nombre de Mach effectif)\n',Angle_fleche_Le*180/pi);
fprintf('|   + Angle de flèche (1/4*c) : %f [deg] \n',Angle_fleche_c4*180/pi);
fprintf('|   + Angle de flèche (1/2*c) : %f [deg] \n',Angle_fleche_c2*180/pi);

%Cl3D calculé avec acomp du cours:

%acomp = a0*cos(Angle_fleche_c2)/(sqrt(1-M_cruise^2*cos(Angle_fleche_c2)^2+(a0*cos(Angle_fleche_c2)/(pi()*A))^2)+a0*cos(Angle_fleche_c2)/(pi()*A));
a = a0*cos(Angle_fleche_c2)/(sqrt(1+(a0*cos(Angle_fleche_c2)/(pi()*A))^2)+a0*cos(Angle_fleche_c2)/(pi()*A));
%acomp = acomp*pi()/180;
Cl3D=a*(incidence(logical(test))-alpha0);
Cl2D=a0*(incidence(logical(test))-alpha0);
CL_Croisiere = Wmoy/(0.5*rho*Vmoy^2*S);
fprintf('| * Cl = %f [rad^-1] * (Alpha - (%f))\n',a,alpha0);
fprintf('| * Cl de croissière = %f \n',CL_Croisiere);
if CL_Croisiere<max(Cl3D)
    alpha_aile_croisiere = alpha0+ CL_Croisiere/a;
    fprintf('| * Angle d attaque croissière : %f [deg]\n',alpha_aile_croisiere*180/pi);
else
    alpha_aile_croisiere = inf;
    fprintf('| * Angle d attaque croissière : NA - Le CL de croissière n est pas dans la partie linéaire du profil\n');
end

%alpha_aile_croisiere=interp1(Cl3D,incidence,CL_Croisiere);

plot(incidence(logical(test)).*180/pi, Cl3D,'-',incidence(logical(test)).*180/pi, Cl2D,'--',incidence.*180/pi,Cl,'k:');
title('Coefficient de Portance');
xlabel('Angle d Attaque (deg)');
ylabel('Coefficient de portance');
grid on;
legend('CL 3D','CL 2D','Profil 4412');


%% Coef de Trainée de l'aile
fprintf('\n--- Trainée de l aile (H_cruise)---\n');

Q = 1; %Aile basse avec congé de raccordement
Remoy = rho*Cmoy*Vmoy/mu(T);
fprintf('| * Re = %d \n',Remoy);

Cf = 0.455/(log(Remoy)^2.58*(1+0.144*(M_real*cos(Angle_fleche_Le))^2)^0.65);   %Coefficient de friction d'une plaque plane
Angle_fleche_epmax=Angle_fleche_Le;  %Solidworks ?
epmax = 12/100; %ratio d'épaisseur max du profil
xcm = 40/100;   %position sur la corde du point d'épaisseur max
FF =(1+0.6/xcm*(epmax)+100*epmax^4)*(1.34*M_cruise^0.18*(cos(Angle_fleche_epmax))^0.28);
Swet = S*(1.977+0.52*(epmax));   %On va tracer l'aile en fonction du profil choisi et aller mesurer ça dans Solidworks

CD0Aile = Cf*FF*Q*Swet/S;
fprintf('| * Cd0 = %d \n',CD0Aile);

%% Coef de Trainée du fuselage
fprintf('\n--- Fuslage ---\n');
l= 51.81756*3.28;% (ft) choix de designer suite au dessin
Aside=4.7*3.28; %(ft)
Atop= 4.5*3.28; %(ft)
d=min([Aside Atop]);     %choix designer

fprintf('| * Géonemtrie - type ellipse \n');
fprintf('|   + Longeur (ft): %f\n',l);
fprintf('|   + Grand Axe (ft): %f\n',Aside);
fprintf('|   + Petit Axe (ft): %f\n',Atop);
fprintf('|   + Diamètre equivalant (ft): %f\n',d);

k_surface = 2.08e-5; % (ft) etat de surface / rugosite
Re_eff = 38.21*(l/k_surface)^1.053; % Reynolds effectif / rugosite (M<1)
Re = min([rho*l*Vmoy/mu(T) Re_eff]);
Cf = 0.455/(log(Re)^2.58*(1+0.144*(M_real)^2)^0.65);
Q_fuselage = 1;
FF_fuselage = 1+60/(l/d)^3+l/(400*d);
Swet_fuselage = pi()*((Aside+Atop)/2)*l;
CD0f=Cf*FF_fuselage*Q*Swet_fuselage/S;
fprintf('| * Re (H_cruse) = %d \n',Re);
fprintf('| * Cd0  = %f \n',CD0f);

%% Trainée d'onde
fprintf('\n--- Trainée d onde ---\n');
%1- Cdw(Ma=1.2)
Cdw = 4*9/2*pi/l^2*(pi*Aside*Atop)^2/S;
Ma_DD_Cl0 = 0.8085;% après lecture graphique du diagrame p36@cours5
Ma_DD = Ma_DD_Cl0-0.05*CL_Croisiere;
Ma_critique = Ma_DD-0.08; % Def de boeing.
M = Ma_critique:1e-2:1.2;
Dw_pts = [Ma_critique Ma_DD 1 1.05 1.2; 0 2e-3 Cdw/2 Cdw Cdw];

% détermination graphique de la trainé d'onde
xdif = diff(Dw_pts(1,:));
ydif = diff(Dw_pts(2,:));
directeur = ydif./xdif;
directeur =[0 directeur(1) 3*directeur(2) directeur(3) -(1.2^2-1)^(-1.5)];
coeff = [Dw_pts;directeur];
P_coeff = zeros(4);
figure('Name','Trainée d onde');
hold on;
for i=1:4
    x1 = coeff(1,i);
    x2 = coeff(1,i+1);
    y1 = coeff(2,i);
    y2 = coeff(2,i+1);
    d1 = coeff(3,i);
    d2 = coeff(3,i+1);
    
    A_coeff = [(x2-x1)^3 (x2-x1)^2;3*(x2-x1)^2 2*(x2-x1)];
    B_coeff = [y2-d1*(x2-x1)-y1;d2-d1];
    P_coeff(i,1:2) = A_coeff\B_coeff;
    P_coeff(i,3) = d1;
    P_coeff(i,4) = y1;
    xx = x1:(x2-x1)/1e2:x2;
    %plot(xx,d1*(xx-x1)+y1,'k');
    %plot(xx,d2*(xx-x2)+y2,'k');
    
    yy = P_coeff(i,1)*(xx-x1).^3+P_coeff(i,2)*(xx-x1).^2+P_coeff(i,3)*(xx-x1)+P_coeff(i,4);
    plot(xx,yy,'b');
    
end
plot(Dw_pts(1,:),Dw_pts(2,:),'k+');

[diff_cruise,I]=sort(abs(Dw_pts(1,:)-M_cruise));
Cdw = P_coeff(I(1),1)*(M_cruise-Dw_pts(1,I(1)))^3+P_coeff(I(1),2)*(M_cruise-Dw_pts(1,I(1)))^2+P_coeff(I(1),3)*(M_cruise-Dw_pts(1,I(1)))+P_coeff(I(1),4);
plot(M_cruise,Cdw,'dr');
grid on;
hold off;
fprintf('| * March Critique  = %f \n',Ma_critique);
fprintf('| * March DD  = %f \n',Ma_DD);
fprintf('| * March Croissière  = %f \n',M_cruise);
fprintf('| * Cdw  = %f \n',Cdw);


%% Coef de Trainée de l'empenage
fprintf('\n--- Empenage ---\n');
fprintf('| * Type d empenage = Conventionnel\n');

C_VT = 0.09; % Valeur du cours 6
C_HT = 1.00; % Valeur du cours 6

lvt = 2/4*l;%(ft) a changer avec les valeurs du cad
lht = 2/4*l;%(ft) idem

S_VT = C_VT *b*S/lvt;
S_HT = C_HT*Cmoy*S/lht;
fprintf('| * ATTENSION les distiances sont prise entre les 2 centres aerodynamiques\n');
fprintf('| * Distance de l empenage Vertival (ft)= %f\n',lvt);
fprintf('| * Surface de l empenage Vertival (ft^2)= %f\n',S_VT);
fprintf('| * Distance de l empenage Horizontal (ft)= %f\n',lht);
fprintf('| * Surface de l empenage Horizontal (ft^2)= %f\n',S_HT);

% Empenage Horizontal
fprintf('| * Empenage Horizontal = NACA0014\n');

AR_HT = 5; % Cours 6, p28 type autre
effilement_ht = 0.6;
b_ht = sqrt(AR_HT*S_HT);
cr_ht = 2*S_HT/(b*(1+effilement_ht));
ct_ht = effilement_ht*cr_ht;
Cmoy_HT = 2*cr_ht/3*(1+effilement_ht+effilement_ht^2)/(1+effilement_ht);

Remoy = rho*Cmoy_HT*Vmoy/mu(T);
Angle_fleche_HT  = Angle_fleche_Le; % A modifier
Angle_fleche_tcmax_HT = Angle_fleche_c4; % A Modifier !
Q_ht = 1.05;
xcm_ht= 0.25; %NACA 0014
tc_ht= 0.14; %NACA 0014

fprintf('|   + Allongement = %f\n',AR_HT);
fprintf('|   + Effilement = %f\n',effilement_ht);
fprintf('|   + Envergure (ft) = %f\n',b_ht);
fprintf('|   + Corde à l emplanture (ft)= %f\n',cr_ht);
fprintf('|   + Corde en bout d aile (ft)= %f\n',ct_ht);
fprintf('|   + Corde moyenne (ft)= %f\n',Cmoy_HT);
fprintf('|   + Re = %d\n',Remoy);
fprintf('|   + Angle de Flèche = %f [deg]\n',Angle_fleche_HT*180/pi);
fprintf('|   + Angle de Flèche 0.25*c = %f [deg]\n',Angle_fleche_tcmax_HT*180/pi);
fprintf('|   + Effet d interférence = %f \n',Q_ht);
fprintf('|   + x/c max = %f \n',xcm_ht);
fprintf('|   + t/c max = %f \n',tc_ht);

Cf = 0.455/(log(Remoy)^2.58*(1+0.144*(M_real*cos(Angle_fleche_HT))^2)^0.65);
Ff_H = 1.10*(1+0.6/xcm_ht*tc_ht+100*(tc_ht)^4)*(1.34*M_cruise^0.18*(cos(Angle_fleche_tcmax_HT))^0.28);
Swet_ht = S*(1.977+0.52*(tc_ht));
CD0_ht = Cf*Ff_H*Q_ht*Swet_ht/S_HT;

fprintf('|   = CD0 = %f \n',CD0_ht);

% Empenage Vertical
fprintf('| * Empenage Vertical = NACA0014\n');

AR_VT = 5; % Cours 6, p28 type autre
effilement_vt = 0.6;
b_vt = sqrt(AR_VT*S_VT);
cr_vt = 2*S_VT/(b*(1+effilement_vt));
ct_vt = effilement_vt*cr_vt;
Cmoy_VT = 2*cr_vt/3*(1+effilement_vt+effilement_vt^2)/(1+effilement_vt);
Remoy = rho*Cmoy_VT*Vmoy/mu(T);
Angle_fleche_VT  = Angle_fleche_Le; % A modifier
Angle_fleche_tcmax_VT = Angle_fleche_c4; % A Modifier !
Q_vt = 1.05;
xcm_vt= 0.25; %NACA 0014
tc_vt= 0.14; %NACA 0014

fprintf('|   + Allongement = %f\n',AR_VT);
fprintf('|   + Effilement = %f\n',effilement_vt);
fprintf('|   + Envergure (ft)=  %f\n',b_vt);
fprintf('|   + Corde à l emplanture (ft)= %f\n',cr_vt);
fprintf('|   + Corde en bout d aile (ft)= %f\n',ct_vt);
fprintf('|   + Corde moyenne (ft)= %f\n',Cmoy_VT);
fprintf('|   + Re = %d\n',Remoy);
fprintf('|   + Angle de Flèche = %f [deg]\n',Angle_fleche_VT*180/pi);
fprintf('|   + Angle de Flèche 0.25*c = %f [deg]\n',Angle_fleche_tcmax_VT*180/pi);
fprintf('|   + Effet d interférence = %f \n',Q_vt);
fprintf('|   + x/c max = %f \n',xcm_vt);
fprintf('|   + t/c max = %f \n',tc_vt);

Cf = 0.455/(log(Remoy)^2.58*(1+0.144*(M_real*cos(Angle_fleche_VT))^2)^0.65);
Ff_V = 1.10*(1+0.6/xcm_vt*tc_vt+100*(tc_vt)^4)*(1.34*M_cruise^0.18*(cos(Angle_fleche_tcmax_VT))^0.28);
Swet_vt = S*(1.977+0.52*(tc_vt));
CD0_vt = Cf*Ff_V*Q_vt*Swet_vt/S_VT;

fprintf('|   = CD0 = %f \n',CD0_vt);

%% Coefficient de trainée à portance null
fprintf('\n--- Coefficient de trainée à portance null ---\n');
CD0_avion = CD0_vt+CD0_ht+CD0Aile+Cdw+CD0f;
fprintf('|   = CD0 = %f \n',CD0_avion);
fprintf('|   = CD = %f \n',CD0_avion+k*CL_Croisiere^2);
fprintf('|   = Finesse = %f \n',CL_Croisiere/(CD0_avion+k*CL_Croisiere^2));


