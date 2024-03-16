clc
clear

options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-5 1e-4 1e-5 1e-4 1e-4]);
format long g
    maxb1 = 4*10^-4;%0, 2*10^-5,4*10^-5, 2.2*10^-4, 4*10^-4
    minb1 = 2.2*10^-4;
    maxb2 = 3*10^-4;%0, 1.5*10^-5,3*10^-5, 1.65*10^-4, 3*10^-4 
    minb2 = 1.65*10^-4;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    maxd1 = 5*10^-5;%10^-7, 2.55*10^-6,5*10^-6 , 2.75*10^-5, 5*10^-5
    mind1 =2.75*10^-5;
    maxd2 =  4*10^-5; %10^-7, 2.05*10^-6,4*10^-6 , 2.2*10^-5, 4*10^-5
    mind2 = 2.2*10^-5;

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    maxw1 = 0.10;%0.08, 0.10, 0.12, 0.14, 0.16
    minw1 = 0.8;
    maxw2 = 0.075;%0.05,0.07, 0.09, 0.105, 0.12 
    minw2 = 0.05;
    %%%%%%%%%%%%%%%%%%%%%%%%%2
    maxr=0.35; %0, 0.35, 0.9, 1.6, 4.6
    minr=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%
b = 1.6;
b1 = 4*10^-5;%4*10^-5;
b2 = 3*10^-5;%3*10^-5;
d1 = 5*10^-6;%5*10^-6;
d2 = 4*10^-6;%4*10^-6;
a = 0.01;
m = 0.00055;
u1 = 0.011;
u2 = 0.013;
gamma1 = 4;
gamma2 = 4;
w1 = 0.11;
w2 = 0.09; 
c = 100;
p = 0.1;
g1 = 0.6;
g2 = 0.6;
r = 0.9;
sigma1 = 0.25;
sigma2 = 0.25;
eta = 0.15;
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    %%%%%%%%%%%%%%%%%%%%%%%%%
    TS=180;% this is the time span for the ODE
    n=2500;% number of simulations
    senario=1
    j=0; 
    TM=zeros(2*TS,n);
    Y1M=zeros(2*TS,n);
    Y2M=zeros(2*TS,n);
    Y3M=zeros(2*TS,n);
    Y4M=zeros(2*TS,n);
    Y5M=zeros(2*TS,n); 
    Y6M=zeros(2*TS,n);     
    %%%%%%%%%%% here we test the upper and lower bounds of R0 befor running
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %here we define different senarios to control the infection
b1_values = [];
b2_values = [];
d1_values = [];
d2_values = [];
u1_values = [];
u2_values = [];
r_values = [];
w1_values=[];
w2_values=[];

    for i=1:n
    j=j+1;  
    if senario ==1% limit direct contacts
        meanb1 = (minb1 + maxb1)/2;
        meanb2 = (minb2 + maxb2)/2;
        varb1 = ((maxb1 - minb1)^2)/12;
        varb2 = ((maxb2 - minb2)^2)/12;
        kb1 = (meanb1^2)/varb1;
        kb2 = (meanb2^2)/varb2;
        thetab1 = varb1/meanb1;
        thetab2 = varb2/meanb2;
        b1 = gamrnd(kb1,thetab1);
        b2 = gamrnd(kb2,thetab2);
        while b1 < minb1 || b1 > maxb1
            b1 = gamrnd(kb1,thetab1);
        end
        while b2 < minb2 || b2 > maxb2
            b2 = gamrnd(kb2,thetab2);
        end
        b1_values = [b1_values; b1];
        b2_values = [b2_values; b2];
  par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    elseif senario ==2% limit indirect contacts
    meand1 = (mind1 + maxd1)/2;
    meand2 = (mind2 + maxd2)/2;
    stdd1 = (maxd1 - mind1)/4; 
    stdd2 = (maxd2 - mind2)/4;
    d1 = normrnd(meand1, stdd1);
    d2 = normrnd(meand2, stdd2);
    while d1 < mind1 || d1 > maxd1
        d1 = normrnd(meand1, stdd1);
    end
    while d2 < mind2 || d2 > maxd2
        d2 = normrnd(meand2, stdd2);
    end
    d1_values = [d1_values; d1];
    d2_values = [d2_values; d2];
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    
    elseif senario ==3% more cleaning
    meanr = (minr + maxr)/2;
    stdr = (maxr - minr)/4; % You can adjust the scaling factor as per your needs
    r = normrnd(meanr, stdr);
    while r < minr || r > maxr
        r = normrnd(meanr, stdr);
    end
    r_values = [r_values; r];
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];

%     par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];

    elseif senario ==4% limit direct and indirect contacts
    meanb1 = (minb1 + maxb1)/2;
        meanb2 = (minb2 + maxb2)/2;
        varb1 = ((maxb1 - minb1)^2)/12;
        varb2 = ((maxb2 - minb2)^2)/12;
        kb1 = (meanb1^2)/varb1;
        kb2 = (meanb2^2)/varb2;
        thetab1 = varb1/meanb1;
        thetab2 = varb2/meanb2;
        b1 = gamrnd(kb1,thetab1);
        b2 = gamrnd(kb2,thetab2);
        while b1 < minb1 || b1 > maxb1
            b1 = gamrnd(kb1,thetab1);
        end
        while b2 < minb2 || b2 > maxb2
            b2 = gamrnd(kb2,thetab2);
        end
    meand1 = (mind1 + maxd1)/2;
    meand2 = (mind2 + maxd2)/2;
    stdd1 = (maxd1 - mind1)/4; 
    stdd2 = (maxd2 - mind2)/4;
    d1 = normrnd(meand1, stdd1);
    d2 = normrnd(meand2, stdd2);
    while d1 < mind1 || d1 > maxd1
        d1 = normrnd(meand1, stdd1);
    end
    while d2 < mind2 || d2 > maxd2
        d2 = normrnd(meand2, stdd2);
    end
    b1_values = [b1_values; b1];
    b2_values = [b2_values; b2];
    d1_values = [d1_values; d1];
    d2_values = [d2_values; d2];
    par = [b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    elseif senario==5%limit direct and more cleaning
        meanb1 = (minb1 + maxb1)/2;
        meanb2 = (minb2 + maxb2)/2;
        varb1 = ((maxb1 - minb1)^2)/12;
        varb2 = ((maxb2 - minb2)^2)/12;
        kb1 = (meanb1^2)/varb1;
        kb2 = (meanb2^2)/varb2;
        thetab1 = varb1/meanb1;
        thetab2 = varb2/meanb2;
        b1 = gamrnd(kb1,thetab1);
        b2 = gamrnd(kb2,thetab2);
        while b1 < minb1 || b1 > maxb1
            b1 = gamrnd(kb1,thetab1);
        end
        while b2 < minb2 || b2 > maxb2
            b2 = gamrnd(kb2,thetab2);
        end
    b1_values = [b1_values; b1];
    b2_values = [b2_values; b2];
        meanr = (minr + maxr)/2;
        stdr = (maxr - minr)/4; % You can adjust the scaling factor as per your needs
        r = normrnd(meanr, stdr);
        while r < minr || r > maxr
        r = normrnd(meanr, stdr);
        end
    r_values = [r_values; r];
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    
    elseif senario==6% limit indirectand more cleaning
     meand1 = (mind1 + maxd1)/2;
    meand2 = (mind2 + maxd2)/2;
    stdd1 = (maxd1 - mind1)/4; 
    stdd2 = (maxd2 - mind2)/4;
    d1 = normrnd(meand1, stdd1);
    d2 = normrnd(meand2, stdd2);
    while d1 < mind1 || d1 > maxd1
        d1 = normrnd(meand1, stdd1);
    end
    while d2 < mind2 || d2 > maxd2
        d2 = normrnd(meand2, stdd2);
    end
    d1_values = [d1_values; d1];
    d2_values = [d2_values; d2];
    meanr = (minr + maxr)/2;
        stdr = (maxr - minr)/4; % You can adjust the scaling factor as per your needs
        r = normrnd(meanr, stdr);
        while r < minr || r > maxr
        r = normrnd(meanr, stdr);
        end
    r_values = [r_values; r];
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    elseif senario==7% adjust w1 and w2
    meanw1 = (minw1 + maxw1)/2;
    stdw1 = (maxw1 - minw1)/4;
    w1 = normrnd(meanw1, stdw1);
    while w1 < minw1 || w1 > maxw1
        w1 = normrnd(meanw1, stdw1);
    end
    meanw2 = (minw2 + maxw2)/2;
    stdw2 = (maxw2 - minw2)/4;
    w2 = normrnd(meanw2, stdw2);
    while w2 < minw2 || w2 > maxw2
        w2 = normrnd(meanw2, stdw2);
    end
    w1_values = [w1_values; w1];
    w2_values = [w2_values; w2];
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    end

    
  [T,Y] = ode45(@SIRSnewModel,[0 TS],[3000 1 1 0 1 2],options,par);

R01d(i)=b1/((u1+m+w1))*(b/m);
R01in(i)=(b/m)*(d1*gamma1)/((eta+r+sigma1)*(u1+m+w1));
R01e(i)=g1/(r+sigma1+eta);
R02d(i)=b2/((u2+m+w2))*(b/m);
R02in(i)=(b/m)*(d2*gamma2)/((r+sigma2)*(u2+m+w2));
R02e(i)=g2/(r+sigma2);

R01TR(i)=0.5*(R01d(i)+R01in(i)+R01e(i)+sqrt((R01d(i)+R01in(i)-R01e(i))^2+4*R01e(i)*R01in(i)));
R02TR(i)=0.5*(R02d(i)+R02in(i)+R02e(i)+sqrt((R02d(i)+R02in(i)-R02e(i))^2+4*R02e(i)*R02in(i)));
MaxR0=max(R01TR,R02TR);
TL=length(T);
TM(1:TL,i)=T;
Y1M(1:TL,i)=Y(:,1);
Y2M(1:TL,i)=Y(:,2);
Y3M(1:TL,i)=Y(:,3);
Y4M(1:TL,i)=Y(:,4);
Y5M(1:TL,i)=Y(:,5);
Y6M(1:TL,i)=Y(:,6);
avgPrS(i)=mean(Y(:,2)./((Y(:,1))+(Y(:,2))+(Y(:,3))+(Y(:,4))));
avgPrR(i)=mean(Y(:,3)./((Y(:,1))+(Y(:,2))+(Y(:,3))+(Y(:,4))));
maxPrS(i)=max(Y(:,2)./((Y(:,1))+(Y(:,2))+(Y(:,3))+(Y(:,4))));
maxPrR(i)=max(Y(:,3)./((Y(:,1))+(Y(:,2))+(Y(:,3))+(Y(:,4))));
minPrS(i)=min(Y(:,2)./((Y(:,1))+(Y(:,2))+(Y(:,3))+(Y(:,4))));
    end
Maxprs=round (max(maxPrS)*100, 4)
MaxprR=round (max(maxPrR)*100, 4)
AvgPrS=round (mean(avgPrS)*100, 4)
AvgprR=round (mean(avgPrR)*100, 4)
%%%%%%%%%%%%%%%%%%%%
AvgR01d = round(mean(R01d), 2)
AvgR01in = round(mean(R01in), 2)
AvgR01e = round(mean(R01e), 2)
AvgR02d = round(mean(R02d), 2)
AvgR02in = round(mean(R02in), 2)
AvgR02e = round(mean(R02e), 2)
AveR0 = round(mean(MaxR0), 2)
AvgR01TR=mean(R01TR);
SEM = std(R01TR)/sqrt(length(R01TR));            
ts = tinv([0.025  0.975],length(R01TR)-1);        
CI_R01TR =round( (mean(R01TR) + ts*SEM), 4)

%%%%%%%%%%%%%
AvgR02TR=mean(R02TR);
SEM = std(R02TR)/sqrt(length(R02TR));             % Standard Error
ts = tinv([0.025  0.975],length(R02TR)-1);        % T-Score
CI_R02TR = round((mean(R02TR) + ts*SEM), 4)
%%%%%%%%%%%%%%%

AvgR01TR = round(mean(R01TR), 2)
AvgR02TR = round(mean(R02TR), 2)
R01TR = round(R01TR, 2);
R02TR = round(R02TR, 2);
MaxR0 = round(MaxR0, 2);
bm=max(b1_values, b2_values);
dm=max(d1_values, d2_values);
wm=max(w1_values,w2_values);






























































