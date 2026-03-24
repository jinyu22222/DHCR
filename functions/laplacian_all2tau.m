function L=laplacian_all2tau(dim,tau)
    ell_1 = zeros(1, dim(1));  % 预分配内存（仅1次）
    ell_1(1) = 2 * tau(1);     % 中心系数
    % 向量化赋值：前tau(1)个位置和后tau(1)个位置设为-1（无需循环）
    if tau(1) >= 1
        idx1_front = 2 : tau(1) + 1;          % 前侧索引（2~tau1+1）
        idx1_back = dim(1) - tau(1) + 1 : dim(1);  % 后侧索引（n1-tau1+1~n1）
        ell_1(idx1_front) = -1;  % 批量赋值前侧
        ell_1(idx1_back) = -1;   % 批量赋值后侧
    end
    % --------------------------2. 向量化构造ell_2（第2维拉普拉斯）--------------------------
    ell_2 = zeros(1, dim(2));  % 预分配内存（仅1次）
    ell_2(1) = 2 * tau(2);     % 中心系数
    % 向量化赋值：前tau(2)个位置和后tau(2)个位置设为-1（无需循环）
    if tau(2) >= 1
        idx2_front = 2 : tau(2) + 1;          % 前侧索引（2~tau2+1）
        idx2_back = dim(2) - tau(2) + 1 : dim(2);  % 后侧索引（n2-tau2+1~n2）
        ell_2(idx2_front) = -1;  % 批量赋值前侧
        ell_2(idx2_back) = -1;   % 批量赋值后侧
    end
    ell_3 = zeros(1, dim(3));  % 预分配内存（仅1次）
    ell_3(1) = 2 * tau(3);     % 中心系数
    % 向量化赋值：前tau(2)个位置和后tau(2)个位置设为-1（无需循环）
    if tau(3) >= 1
        idx3_front = 2 : tau(3) + 1;          % 前侧索引（2~tau2+1）
        idx3_back = dim(3) - tau(3) + 1 : dim(3);  % 后侧索引（n2-tau2+1~n2）
        ell_3(idx3_front) = -1;  % 批量赋值前侧
        ell_3(idx3_back) = -1;   % 批量赋值后侧
    end
 % ell_3 = [1,0,0];
 L = ell_1'.* ell_2 .* reshape(ell_3, 1, 1, []);
end