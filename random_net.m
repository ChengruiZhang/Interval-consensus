% validation of interval consensus of random network
function y = random_net(W, iter, x0, limitation)
% input: W-Laplacian matrix; iter-maximum iteration num;
% x0-init state; limitation-limitation of each node
%% 
L = size(x0, 1); y = zeros(L, iter); y(:, 1) = x0;
for j = 2 : iter 
    tmp = zeros(L, 1);
    N = random_N(W, L); % generate random graph, negative diag
    for i = 1 : L
        x_sat = sat(y(:,j-1), limitation, i, L); % saturation for line i
        tmp(i) = N(i, :) * x_sat;
    end
    y(:, j) = y(:, j-1) + e * tmp;
    if j == 50
        y(:, j) = y(:, j) + [0.5, -1, -0.5, 1]';
    end
end

%% plot
for i = 1 : L
    stairs(1:iter, y(i, :),'LineWidth',1)
    hold on; grid on
end
axis([0,200,-5.5, 5.5])
xlabel('iteration','FontName','Times New Roman','FontSize',10);ylabel('x_i(t)','FontName','Times New Roman','FontSize',10);
legend('Node 1', 'Node 2', 'Node 3', 'Node 4')
hold off
end

%% generate random graph
function N = random_N(W, L)
% input: graph matrix-W, matrix size-L
% output: graph matrix-N
tmp = rand(L, L)*0.5;
tmp = tmp + tmp';
N = W .* double(tmp>0.5);
for i = 1 : L
    N(i, i) = 0;
    N(i, i) = -sum(N(i, :), 2);
end
end

%% saturation
% judge whether the transformation exceed the boundary
function x_sat = sat(x, limitation, i, L)
% input: x-current value; limitation; i-current node; L-size
x_sat = x;
for k = 1 : L
    if k == i
        continue
    end
    if limitation(k, 1) >= x(k)
        x_sat(k) = limitation(k, 1); continue
    end
    if limitation(k, 2) <= x(k)
        x_sat(k) = limitation(k, 2); continue
    end
end
end