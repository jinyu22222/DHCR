function [psnr, ssim] = Videos_QA(Vid1, Vid2)
maxP=max(Vid1, [], 'all');
psnr = PSNR(Vid1, Vid2, maxP);
ssim = ssim_index(Vid1, Vid2);

