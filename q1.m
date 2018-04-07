clear;
clc;

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
    figure(1);
    plot(Vin,V(5),'o');
    hold on;
    plot(Vin,V(8),'*');
    title('DC sweep');
    xlabel('Vin(V)');
    ylabel('Vo and V3 (V)');
    hold on;
    pause(0.1);
     
end

w=logspace(-2,5,500);
for N=1:length(w)
    Vac=(Ghat+1i*w(N)*Chat)\F;
    gain=20*log10(abs(Vac(8)/Vin));
    figure(2);
    semilogx(w(N),gain,'*');
    ylabel('Gain');
    xlabel('frequency(Hz)');
    hold on;
    grid on;
    
    figure(3);
    semilogx(w(N),abs(Vac(8)),'*');
    ylabel('Vo(V)');
    xlabel('frequency(Hz)');
    hold on;
    grid on;  
end

w=pi;
C=[];
gain=[];
for N=1:10000
    C(N)=0.25+0.05*randn();
    Chat(1,2)=C(N);
    Chat(1,3)=-C(N);
    Chat(2,2)=-C(N);
    Chat(2,3)=C(N);
    Vac=(Ghat+1i*w*Chat)\F;
    gain(N)=abs(Vac(8)/Vin);
end
figure(4);
hist(gain,100);






