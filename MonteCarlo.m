 
%% Monte Carlo %%
clearvars;
bits=input("number of bits:= ");
SNRdB=0:0.5:8;
Nsim=20000;  
SNRlin=10.^(SNRdB/10);
r=1/2; %rate of the encoder
 BerBSC=zeros(1,length(SNRdB));      %creating an array to calculate perror.
BerBEC=zeros(1,length(SNRdB));
BerAWGN=zeros(1,length(SNRdB));
channel=3;     %channel 3=BSC,2=BEC,1=AWGN
while(channel) %three time loop...,for  calculation of perror for three channel one by one.
    [EncoderOutput,m1]=encoder(bits); % calling encoder function
 
for i1 = 1:length(SNRdB)   
    for j1 = 1:Nsim   
        y=channelcoding(EncoderOutput,channel,i1); %calling channelcoding function
       DecoderOutput=viterbi(y,channel);  %calling viterbi function
       
       for i=bits+2:-1:1
             if (xor(m1(i),DecoderOutput(i))==1&&channel==3)    %calculating error bits for Nsim,BSC
        BerBSC(i1)=BerBSC(i1)+1;
    elseif(xor(m1(i),DecoderOutput(i))==1&&channel==2)  %calculating error bits for Nsim,BEC
       BerBEC(i1)=BerBEC(i1)+1;
    elseif (xor(m1(i),DecoderOutput(i))==1&&channel==1) %calculating error bits for Nsim,AWGN
        BerAWGN(i1)=BerAWGN(i1)+1;
             end
       end 
    end       
if(channel==1) %AWGN
 BerAWGN(i1)= BerAWGN(i1)/bits;  % perror errorbits/totalbits
   BerAWGN(i1)= BerAWGN(i1)/Nsim; % i calculated errorbits for Nsims so dividing it by Nsim
elseif(channel==2) %BEC
   BerBEC(i1)= BerBEC(i1)/bits;
    BerBEC(i1)= BerBEC(i1)/Nsim;
elseif(channel==3) %BSC
   BerBSC(i1)= BerBSC(i1)/bits;
     BerBSC(i1)= BerBSC(i1)/Nsim;  
end
end
channel=channel-1;
end   % ending while loop 
close all;
figure(1);
semilogy(SNRdB,BerBSC,'o-','LineWidth',2,'markerfacecolor','b','markeredgecolor','b');
hold on;
semilogy(SNRdB,BerAWGN,'^-','LineWidth',2,'color',[0 0.5 0],'markerfacecolor',[0 0.5 0],'markerfacecolor',[0 0.5 0]);
hold on;
semilogy(SNRdB,BerBEC,'d-','LineWidth',2,'color',[0 0.4 0.9],'markerfacecolor',[0 0.4 0.9],'markerfacecolor',[0 0.4 0.9]);
axis([0 8 10^-7 1])
set(gca,'xtick',0:0.5:8)
grid on;
legend('BSC', 'Gaussian Noise','BEC');
xlabel('SNR per Bit in dB');
ylabel('Probabillity of Bit Error');
saveas(gcf,'projectBasic.jpg','jpg')

