Projet;

Pol =  importdata('xf-naca4412-il-1000000-n5.txt');


mu =@(T)((8.8848e-15*(T^3)-3.2398e-11*(T^2)+6.2657e-8*T+2.3543e-6)/9.81)*(1/3.28)^2*2.2048;%(lb.sec/ft^2)
Angle_fleche_Le=30*pi/180;   %angle de flèche historique réduisant le nombre de Mach effectif (rad)
Effilement=0.17;    %effilement minimisant la trainée induite pour une aile trapézoïdale
    
Q = 1; %Aile basse avec congé de raccordement



