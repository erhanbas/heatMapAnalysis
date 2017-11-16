function T = colorcluster(X, T, k, m)
% find local clustering

n = m;
while n > 1
    n = n-1;
    if X(n,1) == k % node k is not a leave, it has subtrees
        T = colorcluster(X, T, k, n); % trace back left subtree
        T = colorcluster(X, T, X(n,2), n);
        break;
    end
end
T(m) = 1;