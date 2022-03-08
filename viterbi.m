function[DecoderOutput]=viterbi(y,channel)
   %% Viterbi Decoder for BSC,BEC,AWGN  
   bits=length(y)/2-2;
 Bits=bits+2; %%'Bits' is total number of bits of decoderoutput. 
DecoderOutput=zeros(1,Bits);
       %branch metric unit
BMetric=zeros(8,Bits); 
TwoBits=zeros(1,2); 
c=1; 
for i=1:2:2*Bits-1   % taking 2 bits at a time(because r=1/2)
    TwoBits(1)=y(i);  
    TwoBits(2)=y(i+1); % calculating branchmetric,hamming distance between evry possible bit.
    if(channel==2||channel==3) %viterbi hard decision for BSC,BEC
        BMetric(1,c)=mod(TwoBits(1),2)+mod(TwoBits(2),2);      %00
        BMetric(4,c)=BMetric(1,c);
        BMetric(2,c)=mod(TwoBits(1)+1,2)+mod(TwoBits(2)+1,2);  %11
        BMetric(3,c)=BMetric(2,c); 
        BMetric(5,c)=mod(TwoBits(1)+1,2)+mod(TwoBits(2),2);   %10
        BMetric(8,c)=BMetric(5,c); 
        BMetric(6,c)=mod(TwoBits(1),2)+mod(TwoBits(2)+1,2);   %01
        BMetric(7,c)=BMetric(6,c);
    else  
        %viterbi soft decision for AWGN(channel=1)
         ED1=sqrt((TwoBits(1)+1)*(TwoBits(1)+1)+(TwoBits(2)+1)*(TwoBits(2)+1));   %00
    ED2=sqrt((TwoBits(1)-1)*(TwoBits(1)-1)+(TwoBits(2)-1)*(TwoBits(2)-1));   %11
    ED3=sqrt((TwoBits(1)-1)*(TwoBits(1)-1)+(TwoBits(2)+1)*(TwoBits(2)+1));   %10
    ED4=sqrt((TwoBits(1)+1)*(TwoBits(1)+1)+(TwoBits(2)-1)*(TwoBits(2)-1));   %01
    BMetric(1,c)=ED1; BMetric(2,c)=ED2;
    BMetric(4,c)=ED1; BMetric(3,c)=ED2;    
    BMetric(5,c)=ED3; BMetric(6,c)=ED4;
    BMetric(8,c)=ED3; BMetric(7,c)=ED4; 
    end    
c=c+1;
end          
% Path-Metric unit %%
 d1=1; d2=2;
PMetric=zeros(4,Bits+1);   %  metrix of 4 rows because there are 4 paths.
TraIndex=zeros(4,Bits);  % metrix of 4 rows for storing trace index
for i=1:Bits    % summarizing branchmetric to get metrics for 2^(k-1) paths. %here,k=3 so 4 paths.                        
    PMetric(1,i+1)=min(PMetric(1,i)+BMetric(1,i),PMetric(2,i)+BMetric(3,i));
     PMetric(2,i+1)=min(PMetric(3,i)+BMetric(5,i),PMetric(4,i)+BMetric(7,i));
     PMetric(3,i+1)=min(PMetric(1,i)+BMetric(2,i),PMetric(2,i)+BMetric(4,i));
      PMetric(4,i+1)=min(PMetric(3,i)+BMetric(6,i),PMetric(4,i)+BMetric(8,i));
       D1=PMetric(1,i)+BMetric(1,i);
      D2=PMetric(3,i)+BMetric(5,i);
      D3=PMetric(1,i)+BMetric(2,i);
      D4=PMetric(3,i)+BMetric(6,i);
    if PMetric(1,i+1)==D1   
        TraIndex(1,i)=d1;     
    else
        TraIndex(1,i)=d2;
    end 
    if PMetric(3,i+1)==D3
         TraIndex(3,i)=d1;
    else
         TraIndex(3,i)=d2;
    end
    if PMetric(2,i+1)==D2
        TraIndex(2,i)=d1+2;
    else
        TraIndex(2,i)=d2+2;
    end    
    if PMetric(4,i+1)==D4
        TraIndex(4,i)=d1+2;
    else
        TraIndex(4,i)=d2+2;
    end    
end
% Trace Back unit       %trace back follows FILO(first in last out).
                         % restroing  maximum likelihood path from 
                         %the decision made by PMU  using TraIndex.                  
  pos2=TraIndex(1,Bits);
 pos1=TraIndex(pos2,Bits-1);                           
for i=Bits:-1:2            
       
    if(i~=Bits)
        pos2=pos1;
        pos1=TraIndex(pos2,i-1);
    end
    if (pos2==d1&&pos1==d1)||(pos2==d1&&pos1==d2)
       DecoderOutput(1,i-1)=0;
    elseif((pos2==d2&&pos1==d1+2)||(pos2==d2&&pos1==d2+2))
         DecoderOutput(1,i-1)=0;
    else
       DecoderOutput(1,i-1)=1;
    end 
end
return;
