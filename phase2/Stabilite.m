Aero;

%% Calcul dela marge statique (M�thode simple)

Xnp_c = 0.25;
Xgc_c = 0.20; % A MODIFIER !!
MS = Xnp_c - Xgc_c;

if (MS > 0) 
    fprintf('Stabilit� statique\n');
else
    fprintf('Pas de stabilit� statique\n');
end

%% Calcul dela marge statique (M�thode d�taill�e)

Xgc_c = 0.20; % A MODIFIER !!
Xac_c = 0.15; % A MODIFIER !!
n_HT = 1; % On suppose ! 0.8 < n_Ht < 1.2
CL_alpha_wb = a;
CL_alpha_t = 3.5; % A MODIFIER !!
depsilon_dalpha = (2*CL_alpha_wb)/(pi*A);

Xnp_c = Xac_c + n_HT*C_HT*(1 - depsilon_dalpha)*(CL_alpha_t/CL_alpha_wb);
MS = Xnp_c - Xgc_c;

if (MS > 0) 
    fprintf('Stabilit� statique\n');
else
    fprintf('Pas de stabilit� statique\n');
end