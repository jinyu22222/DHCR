 load('suzie100.mat');
X0=data;
dim=size(X0);
missingrate = 0.8;
tau = [2,2,1,1];
 maxiter = 200;
 L=laplacian4D_2tau(dim,tau);
  gamma = 1e3; 
  rho=1.25;
  mu = 1e-4;
   tic;
   Results= TLCR_TC4D_fast(X0, gamma, L, rho, mu, missingrate, maxiter);
    Time = toc;
     [PSNR, SSIM, FSIM] = calculateVideoMetrics(X0, Results);
    ERGAS=ergas(data, Results);
    fprintf('====== QA Results ======\n');
fprintf(' %5.5s  %5.5s  %5.5s  %5.5s  \n',...
    'PSNR', 'SSIM','ERGAS','Time');
    fprintf(' %5.3f   %5.3f   %5.3f  %5.3f   \n',...
      PSNR, SSIM, ERGAS,Time); 
fprintf('======Show Results =====\n');