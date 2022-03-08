function[y]=channelcoding(EncoderOutput,channel,i1)
SNRdB=0:0.5:8;
Nsim=20000;  
n=length(EncoderOutput);
SNRlin=10.^(SNRdB/10);
r=1/2; %rate of the encoder
 sigma2 = 1./(2*r*SNRlin);% for Gaussian Channel
 sigma = sqrt(sigma2);
 p=qfunc(sqrt(2*r*SNRlin));
        if (channel==3)         
            %%BSC
            BSCOutput=EncoderOutput;              
            for i=1:n
                error= rand < p(i1); % if error 1 than that bit will be flipped.            
                if(error)
                    if(EncoderOutput(i)==1)
                        BSCOutput(i)=0;
                    else
                        BSCOutput(i)=1;
                    end
                end
            end
            y=BSCOutput;   
              
        elseif (channel==2)          
            %BEC
            BECOutput=EncoderOutput;               
            for i=1:n
                error= rand < p(i1);
                          
                if(error)
                    BECOutput(i)=-1;  %-1 denotes eraser of bit.
                end
            end          
            y=BECOutput;        
        elseif(channel==1)   %Gaussian Noise            
            GaussianOutput=EncoderOutput;
            St=1;
          for i=1:n   
              if( GaussianOutput(i)==1) % 1 for bit 1 and -1 for bit 0.
                  GaussianOutput(i)=St;
              else 
                   GaussianOutput(i)=-St;
              end
          end
                   
            N = sigma(i1)*randn(1,n);  % different noise for every bit accroding SNR         
            GaussianOutput=GaussianOutput + N;      
           y=GaussianOutput;   
        end
        return;
              