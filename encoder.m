function[EncoderOutput,m1]=encoder(bits)
  %% Encoder
  m=zeros(1,bits);
  m1=zeros(1,bits+2);
%Random bit  Generator
for i=1:bits
    m(i)=randi(2,1)-1;
    m1(i)=m(i);
end
n=2*bits+4;  
x1=zeros(1,2);
m=[x1,m,x1]; 

% Encoding part
k=1;
EncoderOutput=zeros(1,n);
for i=1:2:n
    EncoderOutput(i)=mod(m(k)+mod(m(k+1)+m(k+2),2),2); % g1=1 1 1
    EncoderOutput(i+1)=mod(m(k+2)+m(k),2);             % g2=1 0 1
    k=k+1;
end
return;
