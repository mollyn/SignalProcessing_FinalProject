function [mu,sig] = muinvn(a,w)
% results here are a moving average and stable inverse centered norm based
% on Accurate Sum and Dot Product, Ogita et al

mu = sum2s(a,w)./w;
sig = zeros(length(a)-w+1,1);

for i = 1:length(mu)
    sig(i) = dot2s(a(i:i+w-1)-mu(i),a(i:i+w-1)-mu(i));
end
sig = 1./sqrt(sig);
end


function [ res ] = sum2s(p,w)   
   mlen = length(p)-w+1;
   res = zeros(mlen,1);
   pi_k = p(1);
   sig_k = 0;
   
   for i = 2:w
       [pi_k,q] = TwoSum(pi_k,p(i));
       sig_k = sig_k + q;
   end
   
   res(1) = pi_k + sig_k;
   
   for i = w+1:length(p)
       pi_k_rem = -1*p(i-w);
       [pi_k,q] = TwoSum(pi_k,pi_k_rem);
       sig_k = sig_k + q;
       [pi_k,q] = TwoSum(pi_k,p(i));
       sig_k = sig_k + q;
       res(i-w+1) = pi_k + sig_k;
   end
   
end

function [x,y] = TwoSum(a,b)
   x = a+b; 
   z = x-a;
   y = ((a-(x-z))+(b-z));

end

function res = dot2s(x,y)
    [p,s] = TwoProduct(x(1),y(1));
    n = length(x);
    for i = 2:n
        [h,r] = TwoProduct(x(i),y(i));
        [p,q] = TwoSum(p,h);
        s = s + (q + r);
    end
    res = p+s;
end


function [x,y] = TwoProduct(a,b)
    x = a*b;
    [a1,a2] = Split(a);
    [b1,b2] = Split(b);
    y = a2*b2 - (((x-a1*b1) - a2*b1) - a1*b2);
end

function [x,y] = Split(a)
    c = ((2^27) + 1)*a;
    x = (c-(c-a));
    y = a - x;

end



