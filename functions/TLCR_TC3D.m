function [X,err] = TLCR_TC3D(X0, gamma, tau, rho, mu, missingrate,max_iter)
%% toolbox
addpath(genpath('high-order tensor-SVD Toolbox'));
dim =size(X0);
n = prod(dim); 
Pomega=round(rand(dim(1),dim(2),dim(3)) + 0.5 - missingrate);
Pomegac  = 1-Pomega;
tol      = 1e-4; 
max_mu   = 1e10;

%% variables initialization
 PAM = X0.*Pomega;
 L=laplacian_all2tau(dim,tau); 
 L_bar = fftn(L);
 L_bar_2 =  abs(L_bar).^2;
 L_term = (gamma / n) * L_bar_2; 
 R    = zeros(dim); 
 N    = zeros(dim); 
%% main loop
iter = 0;
while iter<max_iter
    iter = iter + 1;  
    %% Update X: 
     a = real(ifftn(R-N/mu,dim));
     X= PAM+ a.* Pomegac;
     X= max(min(X, 1), 0);  % 截断到[0,1]避免数值溢出

    %% Updata R -- complex proximal operator of l1
     
     X_bar = fftn(X,dim);
     z = X_bar+N/mu;
     abs_z = abs(z);
     soft_thresh_val = max(abs_z - 1 / mu, 0);
     soft_thresh = soft_thresh_val .* z ./ (abs_z + eps);
     denominator = 1 + L_term / mu;
      R = soft_thresh ./ denominator;

    %% Stop criterion   
     dR  =  X_bar-R;    
     chg  = max(abs(dR(:)));

    if chg < tol
         break;
    end    
       %% Update detail display
        if iter == 1 || mod(iter, 20) == 0
            err = norm(dR(:),'fro');
            disp(['iter= ' num2str(iter) ', mu=' num2str(mu) ...
                   ', chg=' num2str(chg) ...
                     ', err=' num2str(err) ]); 
        end 
     
    %% Update mulipliers
    N = N+mu*dR;
    mu = min(rho*mu,max_mu);
end

end

