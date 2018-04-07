clear;
clc;

% This is a low-pass filter
% Definition of low-pass filter
R1=1;
C=0.25;
R2=2;
L=0.2;
R3=10;
alpha=100;
R4=0.1;
R0=1000;

Chat=zeros(8,8);
Chat(1,2)=C;
Chat(1,3)=-C;
Chat(2,2)=-C;
Chat(2,3)=C;
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
    F=zeros(8,1);
    F(7,1)=Vin;
    V=Ghat\F;
end

dt=0.001;
F=zeros(8,1);
V1=zeros(8,1);
Vp=V1;
A=Chat/dt+Ghat;
Vo1=zeros(1,1000);
Vi1=zeros(1,1000);
for t=0:dt:1
    if t>=0.03
        F(7,1)=1;
        Vi1(1,round(t*1000))=1;
    end
    V1=inv(A)*(Chat*Vp/dt+F);
    Vp=V1;   
    if t>0
        Vo1(1,round(t*1000))=V1(8);
    end
end
t=linspace(0,1,1000);
figure(1);
subplot(1,2,1);
plot(t,Vo1);
title('Step Transistion at 0.03s');
xlabel('t(s)');
ylabel('Vo(V)');
subplot(1,2,2);
plot(t,Vi1);
title('Step Transistion at 0.03s');
xlabel('t(s)');
ylabel('Vi(V)');


F=zeros(8,1);
V2=zeros(8,1);
Vp=V2;
f=1/0.03;
Vo2=zeros(1,1000);
Vi2=zeros(1,1000);
for t=0:dt:1
    F(7,1)=sin(2*pi*f*t);
    if t>0
        Vi2(1,round(t*1000))=sin(2*pi*f*t);
    end
    V2=inv(A)*(Chat*Vp/dt+F);
    Vp=V2; 
    if t>0
        Vo2(1,round(t*1000))=V2(8);
    end
end
t=linspace(0,1,1000);
figure(2);
subplot(1,2,1);
plot(t,Vo2);
title('Sinusoidal Input at f=1/0.03 1/s');
xlabel('t(s)');
ylabel('Vo(V)');
subplot(1,2,2);
plot(t,Vi2);
title('Sinusoidal Input at f=1/0.03 1/s');
xlabel('t(s)');
ylabel('Vi(V)');


F=zeros(8,1);
V3=zeros(8,1);
Vp=V3;
Vo3=zeros(1,1000);
Vi3=zeros(1,1000);
for t=0:dt:1
    F(7,1)=1/(0.03*sqrt(2*pi))*exp(-0.5*((t-0.06)/0.03)^2);
    if t>0
        Vi3(1,round(t*1000))=1/(0.03*sqrt(2*pi))*exp(-0.5*((t-0.06)/0.03)^2);
    end
    V3=inv(A)*(Chat*Vp/dt+F);
    Vp=V3;
    
    if t>0
        Vo3(1,round(t*1000))=V3(8);
    end
end
t=linspace(0,1,1000);
figure(3);
subplot(1,2,1);
plot(t,Vo3);
title('Guassian pulse');
xlabel('t(s)');
ylabel('Vo(V)');
subplot(1,2,2);
plot(t,Vi3);
title('Guassian pulse');
xlabel('t(s)');
ylabel('Vi(V)');
    
%FT of Step Transition
fs=20;
n=length(Vi1);
X=fft(Vi1);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
figure(5);
subplot(1,2,1);
plot(fshift,powershift);
title('Step Input');
xlabel('f(Hz)');
ylabel('Vi(V)');

n=length(Vo1);
X=fft(Vo1);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
subplot(1,2,2);
semilogy(fshift,powershift);
title('Step Input');
xlabel('f(Hz)');
ylabel('Vo(V)');

%FT of Sinusoidal Input
n=length(Vi2);
X=fft(Vi2);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
figure(4);
subplot(1,2,1);
plot(fshift,powershift);
title('Sinusoidal Input');
xlabel('f(Hz)');
ylabel('Vi(V)');

n=length(Vo2);
X=fft(Vo2);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
subplot(1,2,2);
semilogy(fshift,powershift);
title('Sinusoidal Input');
xlabel('f(Hz)');
ylabel('Vo(V)');

%FT of Gaussian Pulse
n=length(Vi3);
X=fft(Vi3);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
figure(6);
subplot(1,2,1);
plot(fshift,powershift);
title('Gaussian pulse Input');
xlabel('f(Hz)');
ylabel('Vi(V)');

n=length(Vo3);
X=fft(Vo3);
Y=fftshift(X);
fshift=(-n/2:n/2-1)*fs/n;
powershift = abs(Y).^2/n;
subplot(1,2,2);
semilogy(fshift,powershift);
title('Gaussian Input');
xlabel('f(Hz)');
ylabel('Vo(V)');

