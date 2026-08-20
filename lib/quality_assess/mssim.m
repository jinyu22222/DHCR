function ret = mssim(X0, X)
    N = size(X0, 3);
    ret = 0;
    for frame = 1:N
        ret = ret + ssim(X0(:,:,frame), X(:,:,frame));
    end
    ret = ret / N;
end