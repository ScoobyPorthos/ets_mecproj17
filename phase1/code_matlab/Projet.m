%= Main file for the calculation 

iterParam(A,Wp,R,TSFC,M,H_cruse,T_loitier,Wr,Wt,WS_TO,T_Wto,Cd0,SL)

%%
%== Mission Parameter
    
    PAX = 70;   % Passager number.
    Crew = 3;   % Crew number.
    Wpax = 200; % Weight for 1 passager (lb).
    Rref = 5000;   % Range in (nautic mille)
    M = 0.85;   % Max Speed
    A = 9.5 ;
    twaiting = 0.5; % Waiting Time in (h)
    hwaiting = 5e3; % Waiting Altitude (ft)
    %hcruse = 40e3; % Crusing Altitude (ft)
    TSFC = 0.5;
    
    Range = [5000:100:7000];
    Wpayload = ([70:80]+3)*220;
    hcruse = [36e3:1e3:39e3];
    W = zeros(size(Range,2),size(Wpayload,2),size(hcruse,2),3);
    for i=1:size(Range,2)
        for j=1:size(Wpayload,2)
            for k=1:size(hcruse,2)
                [ Wto, Wfuel, Wempty ] = itertow('jet-transport',M, hcruse(k), A, TSFC, twaiting*60, 0.05, 0.01, Wpayload(j), Range(i));
                W(i,j,k,:) = [Wto Wfuel Wempty];
            end
        end
    end

    
  for i=1:8
    subplot(4,2,i);
    plot(Range,W(:,:,floor((i-1)/2)+1,mod(i-1,2)+1)/1e3);
    grid on;
  end
