%% add title and position
function [rgb] = func_hyperImshow( hsi, RGBbands, hsi_title, position)
hsi=double(hsi);
[rows, cols, bands] = size(hsi);

minVal =min(hsi(:));
maxVal=max(hsi(:));
normalizedData=hsi-minVal;

if(maxVal==minVal)
    normalizedData=zeros(size(hsi));
else
    normalizedData=normalizedData./(maxVal-minVal);
end

hsi=normalizedData;

[rows, cols, bands] = size(hsi);

if (nargin == 1)
    RGBbands = [bands round(bands/2) 1];
end

if (bands ==1)
    red = hsi(:,:);
    green = hsi(:,:);
    blue = hsi(:,:);
else
    red = hsi(:,:,RGBbands(1));
    green = hsi(:,:,RGBbands(2));
    blue = hsi(:,:,RGBbands(3));
end

rgb = zeros(size(hsi, 1), size(hsi, 2), 3);
rgb(:,:,1) = adapthisteq(red);      % Adaptive histogram equalization
rgb(:,:,2) = adapthisteq(green);
rgb(:,:,3) = adapthisteq(blue);

figure;
set(gcf,'position',position);
imshow(rgb,'border','tight','initialmagnification','fit'); axis image;   % 保持图像的显示比例，其中axis为坐标轴的控制函数。
title(hsi_title);
end
