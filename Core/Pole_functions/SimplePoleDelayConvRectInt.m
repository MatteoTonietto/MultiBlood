function y = SimplePoleDelayConvRectInt(par,t1,t2)

a  = par(1);   % exponent
t0 = par(2);   % delay
T  = par(3);   % length of rect


if (T + t0 == t1 &  T + t0 < t2 & t0 < t1)
    y = 1-exp(-T.*a)-exp((t1-t2).*a)+exp(-T.*a+(t1-t2).*a);
elseif (T + t0 < t1)
    y = exp(t0.*a+t1.*a-(t1+t2).*a)-exp(T.*a+t0.*a+t1.*a-(t1+t2).*a)-exp(t0.*a+t2.*a-(t1+t2).*a)+exp(T.*a+t0.*a+t2.*a-(t1+t2).*a);
elseif (T + t0 < t2 & ((t0 == t1 & T + t0 == t1) || (t0 >= t1 & T + t0 >= t1)))
    y = exp(t0.*a-t2.*a)-exp((T+t0).*a-t2.*a)+T.*a;
elseif (T + t0 > t1 & t0 < t1 & T + t0 < t2)
    y = 1-exp((t0-t1).*a)+exp((t0-t2).*a)-exp((T+t0-t2).*a)+T.*a+t0.*a-t1.*a;
elseif (t0 >= t1 & t0 < t2 & T + t0 >= t2)
    y = -1+exp((t0-t2).*a)-t0.*a+t2.*a;
elseif (t0 < t1 & T + t0 >= t2)
    y = -exp((t0-t1).*a)+exp((t0-t2).*a)-t1.*a+t2.*a;
else
    y = 0;
end

den = (a^2)*(t2-t1);

y = y/den;