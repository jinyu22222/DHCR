function [MAE,RMSE] = Traffic_QA(X0, X, Pomega, miss_num)
%==========================================================================
% Evaluates the quality assessment indices for two RGB Imgaes.
%
% Syntax:
%   [psnr, ssim, fsim] = Img_QA(Img1, Img2)
%
% Input:
%   Img1 - the reference RGB image data array
%   Img2 - the target RGB image data array
% NOTE: RGB image data array is a M*N*3 array for imagery with M*N spatial
%	pixels with RGB channels in DYNAMIC RANGE [0, 255]. If Img1 and Img2
%	have different size, the larger one will be truncated to fit the smaller one.
%
% Output:
%   psnr - Peak Signal-to-Noise Ratio
%   ssim - Structure SIMilarity
%   fsim - Feature SIMilarity
%
%
% by Hailin Wang
%==========================================================================
Pomegac=1-Pomega;
MAE=(1/miss_num)*sum(abs(Pomegac.*X0-Pomegac.*X),'all');
RMSE=1/sqrt(miss_num)*sqrt(sum((Pomegac.*X0-Pomegac.*X).^2,'all'));
