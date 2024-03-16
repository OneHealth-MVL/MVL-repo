function dy = SIRSnewModel(t,y,par)
b=par(1);
b1=par(2);
b2=par(3);
d1=par(4);
d2=par(5);
a=par(6);
m=par(7);
u1=par(8);
u2=par(9);
gamma1=par(10);
gamma2=par(11);
w1=par(12);
w2=par(13);
c=par(14);
p=par(15);
g1=par(16);
g2=par(17);
r=par(18);
sigma1=par(19);
sigma2=par(20);
eta=par(21);
    %y(1) = S
    %y(2) = I1
    %y(3) = I2
    %y(4)=R
    %y(5) =P1
    %y(6)=P2
    dy = zeros(6,1);
    dy(1) = b -(b1*y(2)+b2*y(3)+d1*y(5)+d2*y(6))*y(1)+a*y(4)-m*y(1);                     % dS/dt
    dy(2) = b1*y(1)*y(2)+d1*y(1)*y(5)-(u1+m+w1)*y(2);                                    % dI_s/dt
    dy(3) = b2*y(1)*y(3)+d2*y(1)*y(6)+p*w1*y(2)-(u2+m+w2)*y(3);                          % dI_m/dt
    dy(4) = (1-p)*w1*y(2)+w2*y(3)-(a+m)*y(4);                                            % dR/dt
    dy(5) = gamma1*y(2)+ g1*(1-c*y(5))*y(5)-(r+sigma1)*y(5)-eta*y(5);                    % dP1/dt
    dy(6) = gamma2*y(3)+eta*y(5)+ g2*(1-c*y(6))*y(6)-(r+sigma2)*y(6);                    % dP2/dt
    
    
    