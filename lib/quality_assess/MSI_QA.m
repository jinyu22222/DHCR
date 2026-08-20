function [psnr, ssim, msam, ergas] = MSI_QA(imagery1, imagery2)

[m, n, k] = size(imagery1);
[mm, nn, kk] = size(imagery2);
m = min(m, mm);
n = min(n, nn);
k = min(k, kk);
imagery1 = imagery1(1:m, 1:n, 1:k);
imagery2 = imagery2(1:m, 1:n, 1:k);
psnr_slice = zeros(k, 1);
ssim_slice = zeros(k, 1);
sam_slice = zeros(k, 1);
max_val = 1; %输入数据的最大值
for i = 1:k
    slice1 = imagery1(:, :, i);
     slice2 = imagery2(:, :, i);
     mse = mean( (slice1(:) - slice2(:)).^2 );
    psnr_slice(i) =  10*log10(max_val^2/mse);
    % ---------------------- 计算SSIM ----------------------
    % ssim = ssim + ssim_index(imagery1(:, :, i), imagery2(:, :, i));
        % 自定义SSIM实现（无工具箱依赖，适配0-1数据）
        C1 = (0.01 * max_val)^2;  % 稳定系数（基于峰值）
        C2 = (0.03 * max_val)^2;
        window = fspecial('gaussian', 3, 1.5);  % 3x3高斯窗口
        
        mu1 = imfilter(slice1, window, 'replicate');
        mu2 = imfilter(slice2, window, 'replicate');
        sigma12 = imfilter(slice1 .* slice2, window, 'replicate') - mu1 .* mu2;
        sigma1 = imfilter(slice1.^2, window, 'replicate') - mu1.^2;
        sigma2 = imfilter(slice2.^2, window, 'replicate') - mu2.^2;
        
        ssim_map = ((2*mu1.*mu2 + C1) .* (2*sigma12 + C2)) ...
                  ./ ((mu1.^2 + mu2.^2 + C1) .* (sigma1 + sigma2 + C2));
        ssim_slice(i) = mean(ssim_map(:));
        
        % % ---------------------- 计算SAM ----------------------
        % % 光谱角映射度（弧度），衡量像素向量夹角
        % numerator = slice1 .* slice2;
        % denominator = sqrt(slice1.^2) .* sqrt(slice2.^2) + eps;  % 避免除零
        % cos_theta = numerator ./ denominator;
        % cos_theta = max(min(cos_theta, 1), -1);  % 限制范围（数值稳定性）
        % sam_map = acos(cos_theta);  % 每个像素的角度
        % sam_slice(i) = mean(sam_map(:));  % 切片平均角度
 end

psnr = mean(psnr_slice);
ssim = mean(ssim_slice);
% msam = mean(sam_slice);
sum = 0;
for i = 1:m
    for j = 1:n
       T = imagery1(i,j,:);
       T = T(:)';
       H = imagery2(i,j,:);
       H = H(:)';
       sum = sum + SAM(T, H);
    end
end
msam = sum/(m*n);

ergas = ErrRelGlobAdimSyn(imagery1, imagery2);
end
