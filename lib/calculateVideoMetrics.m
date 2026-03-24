function [avgPSNR, avgSSIM, avgFSIM] = calculateVideoMetrics(X0, X)
% calculateVideoMetrics 计算两个视频 X0 和 X 之间的平均 PSNR, SSIM 和 FSIM
%
% 输入:
%   X0 - 参考视频 (H x W x F) 或 (H x W x C x F)
%   X  - 失真视频 (H x W x F) 或 (H x W x C x F)
%        H = 高度, W = 宽度, C = 通道数, F = 帧数
%        数据类型可以是 uint8, uint16, double (范围 [0, 1]) 等
%
% 输出:
%   avgPSNR - 平均峰值信噪比 (dB)
%   avgSSIM - 平均结构相似性
%   avgFSIM - 平均特征相似性 (如果 'FeatureSIM.m' 存在)
%
% 依赖:
%   - Image Processing Toolbox (用于 psnr 和 ssim)
%   - 'FeatureSIM.m' (用于 FSIM, 需从 MATLAB File Exchange 下载)

% --- 1. 输入验证 ---
if ~isequal(size(X0), size(X))
    error('输入视频 X0 和 X 必须具有相同的维度。');
end

% --- 2. 确定视频维度和帧数 ---
dims = ndims(X0);
if dims == 3
    % 假定为灰度视频: H x W x F
    numFrames = size(X0, 3);
    isColor = false;
    % disp('检测到3D输入，假定为灰度视频 (H x W x F)...');
elseif dims == 4
    % 假定为彩色视频: H x W x C x F
    numFrames = size(X0, 4);
    isColor = true;
    % disp('检测到4D输入，假定为彩色视频 (H x W x C x F)...');
else
    error('输入视频必须是 3D (H x W x F) 或 4D (H x W x C x F) 数组。');
end

if numFrames == 0
    error('视频中没有帧。');
end

% --- 3. 检查 FSIM 依赖 ---
hasFSIM = exist('FeatureSIM', 'file');
if ~hasFSIM
    warning('calculateVideoMetrics:FSIMNotFound', ...
            '未在 MATLAB 路径中找到 "FeatureSIM.m" 函数。\nFSIM 将被跳过，并返回 NaN。\n请从 MATLAB File Exchange 下载 FSIM 的实现。');
end

% --- 4. 初始化存储结果的数组 ---
psnrVals = zeros(numFrames, 1);
ssimVals = zeros(numFrames, 1);
fsimVals = zeros(numFrames, 1);

% --- 5. 逐帧计算 ---
for f = 1:numFrames
    
    % 提取当前帧
    if isColor
        frame0_color = X0(:, :, :, f);
        frameX_color = X(:, :, :, f);
        
        % *************** 错误修正 ***************
        % 将 3D 彩色帧转换为 2D 灰度帧
        % rgb2gray 函数可以正确处理 uint8, double 等类型
        frame0 = rgb2gray(frame0_color);
        frameX = rgb2gray(frameX_color);
        % ****************************************
        
    else
        % 已经是 2D 灰度帧
        frame0 = X0(:, :, f);
        frameX = X(:, :, f);
    end
    
    % (现在, frame0 和 frameX 保证是 2D 矩阵)
    
    % 计算 PSNR
    % psnr 函数在 2D 矩阵上运行
    psnrVals(f) = psnr(frameX, frame0);
    
    % 计算 SSIM
    % ssim 函数现在接收 2D 矩阵，可以安全调用 conv2
    ssimVals(f) = ssim(frameX, frame0);
    
    % 计算 FSIM (如果函数存在)
    if hasFSIM
        % FeatureSIM 函数通常也需要 2D 灰度图
        [fsim_val, ~] = FeatureSIM(frameX, frame0);
        fsimVals(f) = fsim_val;
    else
        fsimVals(f) = NaN; % 标记为未计算
    end
end

% --- 6. 计算平均值 ---
avgPSNR = mean(psnrVals);
avgSSIM = mean(ssimVals);

% 'omitnan' 选项确保在 FSIM 未计算时，mean 函数仍能正常工作（返回 NaN）
avgFSIM = mean(fsimVals, 'omitnan');

end