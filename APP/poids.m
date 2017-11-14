function poids
    global a  A  a0  A_coeff  alpha0  alpha_aile_croisiere  Angle_fleche_c2  Angle_fleche_c4  Angle_fleche_epmax  Angle_fleche_HT  Angle_fleche_Le  Angle_fleche_tcmax_HT  Angle_fleche_tcmax_VT  Angle_fleche_VT  AR_HT  AR_VT  Aside  Atop  b  B_coeff  b_ht  b_vt  C  C_HT  C_VT  CD0  CD0_avion  CD0_ht  CD0_vt  CD0Aile  CD0f  Cdw  Cf  Charge_Ailaire  Cl  Cl2D  Cl3D  CL_Croisiere  CLmax  CLmaxTo  CLmaxTO  Cmoy  Cmoy_HT  Cmoy_VT  coeff  Cr  cr_ht  cr_vt  Crew  Ct  ct_ht  ct_vt  d  d1  d2  diff_cruise  directeur  Dw_pts  Effilement  effilement_ht  effilement_vt  epmax  f  F_max  fclimb  fcruise  fdec  FF  FF_fuselage  Ff_H  Ff_V  fitresult  fl  fland  ft  Fuel_res  Fuel_trap  gamma_montee  gof  H_cruise  i  I  i_fin_max  incidence  incidencefmax  k  k_surface  l  lht  lvt  m  M  M_cruise  M_real  Ma_critique  Ma_DD  Ma_DD_Cl0  mu  opts  p  P  P_coeff  PAX  Pol  q  Q  Q_fuselage  Q_ht  Q_vt  Range  ratio  Re  Re_eff  Remoy  rho  S  S_HT  S_VT  SL  Sto  Swet  Swet_fuselage  Swet_ht  Swet_vt  T  T_loiter  T_Wto  tc_ht  tc_vt  test  Thrust_tot  TSFC  tx_montee  Vmach  Vmoy  Vs  Vto  Wbag  Wempty  Wfuel  Wlanding  Wmoy  Wpayload  Wpeople  WS_climb  WS_climb_int  WS_L  WS_TO  Wto  x1  x2  xcm  xcm_ht  xcm_vt  xData  xdif  xx  y1  y2  yData  ydif  yy;
            
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
end