function u = exact(t,x)
    %u = 1-cos(t)+exp((-x.^2)/(1+4*t))/sqrt(1+4*t);
    u = (1+4*t)^(-3/2)*x.*exp(-x.^2/(1+4*t));
    