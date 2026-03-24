function [X,err] = TLCR_TC4D_fast(X0, gamma, L, rho, mu, missingrate,max_iter)
feature accel on;
fft_nthreads = feature('numcores')-1;
setenv('OMP_NUM_THREADS', num2str(fft_nthreads));

dim = size(X0);
n = prod(dim); 
rng('default');
Pomega = double(rand(dim(1),dim(2),dim(3),dim(4)) > missingrate);
Pomegac  = 1-Pomega;
tol      = 1e-4; 
max_mu   = 1e10;

%% 变量初始化
PAM = X0.*Pomega;
L_bar = fftn(L);
L_bar_2 = abs(L_bar).^2;
L_term = (gamma / n) * L_bar_2; 
R    = zeros(dim); 
N    = zeros(dim); 
a    = zeros(dim); 
X_bar= zeros(dim); 
z    = zeros(dim); 
dR   = zeros(dim); 
inv_mu = 1/mu; 

iter = 0;
while iter<max_iter
    iter = iter + 1;  
    %% Update X:
    a = real(ifftn(R-N/mu,dim));
    X = PAM + a .* Pomegac;
    X = max(min(X, 1), 0);  

    %% Updata R: 
    X_bar = fftn(X,dim);
    z = X_bar + N*inv_mu; 
    abs_z = abs(z);
    soft_thresh_val = max(abs_z - inv_mu, 0);
    soft_thresh = soft_thresh_val .* z ./ (abs_z + eps);
    denominator = 1 + L_term * inv_mu; 
    R = soft_thresh ./ denominator;

    %% Stop criterion: 
    dR = X_bar - R;
    if mod(iter, 5) == 0 || iter == 1
        chg = max(abs(dR(:)));
    else
        sample_idx = randperm(n, min(1000, n));
        chg = max(abs(dR(sample_idx)));
    end

    if chg < tol
        break;
    end    

    if iter == 1 || mod(iter, 10) == 0
        err = norm(dR(:),'fro');
        disp(['iter= ' num2str(iter) ', mu=' num2str(mu) ...
               ', chg=' num2str(chg) ...
                 ', err=' num2str(err) ]); 
    end 

    %% Update multipliers:
    N = N + mu * dR;
    mu = min(rho*mu,max_mu);
    inv_mu = 1/mu;
end
end