close all;
clear;
clc;

A=1.0033636057;
B=0.0011240272;
C=0.0000016989;
D=0.0000000027;

ea=6378137;
eb=6356752.314245;
e2=(ea*ea-eb*eb)/(ea*ea);


%% 30m
row = 18924;
T=zeros(18924,3);
i=1;

for phi=0.00026949459+32.3:0.00026949459:37.4
    phi1=deg2rad(phi-0.00026949459);
    phi2=deg2rad(phi);
    
    dphi=phi2-phi1;
    phim=(phi1+phi2)/2;
    K=2*ea*ea*(1-e2)*deg2rad(0.00026949459);

    T(i,1)=phi;
    T(i,2)=K*(A*sin(dphi/2)*cos(phim) - B*sin(3*dphi/2)*cos(3*phim) + C*sin(5*dphi/2)*cos(5*phim) - D*sin(7*dphi/2)*cos(7*phim));
    T(i,3)=T(i,2)/T(1,2);
    i=i+1;
end
xlswrite('trapezoid_areas_0.00026949459.xlsx',T);








%% 25km
row = 27;
T=zeros(row,3);
i=1;

for phi=0.22457882+32:0.22457882:38.06362814
    phi1=deg2rad(phi-0.22457882);
    phi2=deg2rad(phi);
    
    dphi=phi2-phi1;
    phim=(phi1+phi2)/2;
    K=2*ea*ea*(1-e2)*deg2rad(0.22457882);

    T(i,1)=phi;
    T(i,2)=K*(A*sin(dphi/2)*cos(phim) - B*sin(3*dphi/2)*cos(3*phim) + C*sin(5*dphi/2)*cos(5*phim) - D*sin(7*dphi/2)*cos(7*phim));
    T(i,3)=T(i,2)/T(1,2);
    i=i+1;
end
xlswrite('trapezoid_areas_0.22457882.xlsx',T);


%% 1km

row = 602;
T=zeros(row,3);
i=1;

for phi=0.008333345+32.308379:0.008333345:37.32505269
    phi1=deg2rad(phi-0.008333345);
    phi2=deg2rad(phi);
    
    dphi=phi2-phi1;
    phim=(phi1+phi2)/2;
    K=2*ea*ea*(1-e2)*deg2rad(0.008333345);

    T(i,1)=phi;
    T(i,2)=K*(A*sin(dphi/2)*cos(phim) - B*sin(3*dphi/2)*cos(3*phim) + C*sin(5*dphi/2)*cos(5*phim) - D*sin(7*dphi/2)*cos(7*phim));
    T(i,3)=T(i,2)/T(1,2);
    i=i+1;
end
xlswrite('trapezoid_areas_0.008333345.xlsx',T);











