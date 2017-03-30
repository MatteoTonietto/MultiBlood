function [X_good,l_good] = DoubleLine(X,lambdagrid)
% Return only the non-zeros coefficients in X and the corresponding 
% nonlinear parameters in lambdagrid. If two consecutive X are non-zeros it
% returns a single X wich is the sum of the two coefficients, while the
% corrisponding lambda is a weighted average


idx      = find(X);
idx_rep  = find(diff(idx)==1);

n_good = length(idx)-length(idx_rep);
X_good = zeros(n_good,1);
l_good = zeros(n_good,1);

k      = 1;
i      = 2;

while k <= n_good
    if idx(min(i,length(idx))) == idx(i-1)+1
        l_good(k)   = (  X(idx(i-1)) * lambdagrid(idx(i-1)) +       ...
                         X(idx(i))   * lambdagrid(idx(i))     ) /   ...
                      (  X(idx(i-1)) + X(idx(i))              );    
        X_good(k)   = X(idx(i-1)) + X(idx(i));
        k           = k + 1;
        i           = i + 2;
    else
        l_good(k)   = lambdagrid(idx(i-1));
        X_good(k)   = X(idx(i-1));
        k           = k + 1;
        i           = i + 1;
    end
end