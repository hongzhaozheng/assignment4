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
    Ghat(8,7)=1;
end

Vp=V

f=(C/dt+G)*V-C/dt*Vp-B-F;

