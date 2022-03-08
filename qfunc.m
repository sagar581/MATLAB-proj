function y = qfunc(x)
if(~isreal(x)||ischar(x))
    error(message('comm:qfunc:invalidArg'));
end
y=0.5*erfc(x/sqrt(2));
return;