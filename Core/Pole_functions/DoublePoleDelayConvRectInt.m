function y = DoublePoleDelayConvRectInt(par,t1,t2)

a  = par(1);   % exponent
t0 = par(2);   % delay
T  = par(3);   % length of rect


if (t0 > t1 & t0 <= t2 & T + t0 > t1 & T + t0 <= t2)
    y = 2.*exp((t0+t1).*a+(-t1-t2).*a)-2.*exp((T+t0+t1).*a+(-t1-t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a+exp((-t1-t2).*a+(t1+t2).*a).*T.*a-exp((t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a;
elseif (t0 > t1 & t0 <= t2 & T + t0 <= t1)
    y = 2.*exp((t0+t1).*a+(-t1-t2).*a)-2.*exp((T+t0+t1).*a+(-t1-t2).*a)+2.*exp((-t1-t2).*a+(T+t0+t2).*a)-2.*exp((-t1-t2).*a+(t1+t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*T.*a-exp((t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*t0.*a-exp((-t1-t2).*a+(t1+t2).*a).*t0.*a+exp((-t1-t2).*a+(T+t0+t2).*a).*t1.*a+exp((-t1-t2).*a+(t1+t2).*a).*t1.*a+exp((t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a;
elseif (t0 <= t1 & T + t0 > t1 & T + t0 <= t2)
    y = 2.*exp((t0+t1).*a+(-t1-t2).*a)-2.*exp((T+t0+t1).*a+(-t1-t2).*a)-2.*exp((-t1-t2).*a+(t0+t2).*a)+2.*exp((-t1-t2).*a+(t1+t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a+exp((-t1-t2).*a+(t1+t2).*a).*T.*a-exp((t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((-t1-t2).*a+(t0+t2).*a).*t0.*a+exp((-t1-t2).*a+(t1+t2).*a).*t0.*a-exp((-t1-t2).*a+(t0+t2).*a).*t1.*a-exp((-t1-t2).*a+(t1+t2).*a).*t1.*a+exp((t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a;
elseif (t0 <= t1 & t0 <= t2 & T + t0 <= t1 & T + t0 <= t2)
    y = 2.*exp((t0+t1).*a+(-t1-t2).*a)-2.*exp((T+t0+t1).*a+(-t1-t2).*a)-2.*exp((-t1-t2).*a+(t0+t2).*a)+2.*exp((-t1-t2).*a+(T+t0+t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*T.*a-exp((t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((-t1-t2).*a+(t0+t2).*a).*t0.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*t0.*a-exp((-t1-t2).*a+(t0+t2).*a).*t1.*a+exp((-t1-t2).*a+(T+t0+t2).*a).*t1.*a+exp((t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a;
elseif (t0 > t2 & T + t0 <= t1 & T + t0 <= t2)
    y = -2.*exp((T+t0+t1).*a+(-t1-t2).*a)+2.*exp((-t1-t2).*a+(T+t0+t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*T.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a-exp((-t1-t2).*a+(T+t0+t2).*a).*t0.*a+exp((-t1-t2).*a+(T+t0+t2).*a).*t1.*a+exp((-t1-t2).*a+(t1+t2).*a).*t1.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((-t1-t2).*a+(t1+t2).*a).*t2.*a;
elseif (t0 > t1 & t0 <= t2 & T + t0 > t2)
    y = -2+2.*exp((t0-t2).*a)-t0.*a-exp((t0-t2).*a).*t0.*a+t2.*a+exp((t0-t2).*a).*t2.*a;    
elseif (t0 <= t1 & t0 <= t2 & T + t0 > t2)
    y = 2.*exp((t0+t1).*a+(-t1-t2).*a)-2.*exp((-t1-t2).*a+(t0+t2).*a)-exp((t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((-t1-t2).*a+(t0+t2).*a).*t0.*a-exp((-t1-t2).*a+(t0+t2).*a).*t1.*a-exp((-t1-t2).*a+(t1+t2).*a).*t1.*a+exp((t0+t1).*a+(-t1-t2).*a).*t2.*a+exp((-t1-t2).*a+(t1+t2).*a).*t2.*a;    
elseif (t0 > t2 & T + t0 > t1 & T + t0 <= t2)
    y = -2.*exp((T+t0+t1).*a+(-t1-t2).*a)+2.*exp((-t1-t2).*a+(t1+t2).*a)+exp((T+t0+t1).*a+(-t1-t2).*a).*T.*a+exp((-t1-t2).*a+(t1+t2).*a).*T.*a+exp((T+t0+t1).*a+(-t1-t2).*a).*t0.*a+exp((-t1-t2).*a+(t1+t2).*a).*t0.*a-exp((T+t0+t1).*a+(-t1-t2).*a).*t2.*a-exp((-t1-t2).*a+(t1+t2).*a).*t2.*a;
else
    y = 0;
end

den = (a^3)*(t2-t1);

y = y/den;