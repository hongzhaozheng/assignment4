clear;
clc;

R1=1;
C=0.25;
R2=2;
L=0.2;
R3=10;
alpha=100;
R4=0.00001;
R0=1000;
Cn=0.00001;
dt=0.001;


Chat=zeros(8,8);
Chat(1,2)=C;
Chat(1,3)=-C;
Chat(2,2)=-C;
Chat(2,3)=C;
Chat(3,5)=Cn;
Chat(6,4)=-L;

for Vin=-10:1:10
    Ghat=zeros(8,8);
    Ghat(1,1)=-1;
    Ghat(1,2)=1/R1;
    Ghat(1,3)=-1/R1;
    Ghat(2,2)=-1/R1;
    Ghat(2,3)=1/R1+1/R2;
    Ghat(2,4)=1;
    Ghat(3,4)=-1;
    Ghat(3,5)=1/R3;
    Ghat(4,6)=-1;
    Ghat(4,7)=1/R4;
    Ghat(4,8)=-1/R4;
    Ghat(5,7)=-1/R4;
    Ghat(5,8)=1/R4+1/R0;
    Ghat(6,3)=1;
    Ghat(6,5)=-1;
    Ghat(7,2)=1;
    Ghat(8,5)=alpha/R3;
    Ghat(8,7)=-1;
end

A=Chat/dt+Ghat;
F=zeros(8,1);
V3=zeros(8,1);
Vp=V3;
Vo3=zeros(1,1000);
for t=0:dt:1
    F(7,1)=1/(0.03*sqrt(2*pi))*exp(-0.5*((t-0.06)/0.03)^2);
    F(3,1)=-0.001*randn();
    V3=inv(A)*(Chat*Vp/dt+F);
    Vp=V3;
    
    if t>0
        Vo3(1,round(t*(1/dt)))=V3(8);
    end
end
t=linspace(0,1,(1/dt));
figure(1);
plot(t,Vo3);
title('Guassian pulse with noise source');
xlabel('t(s)');
ylabel('Vo(V)');

fs=20;
n=length(Vo3);
X=fft(Vo3);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
figure(2);
semilogy(fshift,powershift);
title('Gaussian Input with noise source');
xlabel('f(Hz)');
ylabel('Vo(V)');


