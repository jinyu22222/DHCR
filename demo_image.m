load('img_Lena.mat');%color image
X0 = data;
missingrate = 0.8;
tau = [2,2,1];
gamma = 1e3; 
rho=1.25;
mu = 1e-4;
max_iter=200; 
tic;
[X, err] = TLCR_TC3D(X0, gamma, tau, rho, mu, missingrate,max_iter);
Time = toc;
[PSNR, SSIM] =Img_QA(X0, X);
fprintf('==== QA Results =====\n');
fprintf(' %5.5s  %5.5s   %5.5s  \n',...
    'PSNR', 'SSIM','Time');
fprintf(' %5.3f    %5.3f    %5.3f   \n',...
         PSNR, SSIM,  Time); 
fprintf('==== Show Results ===\n');
