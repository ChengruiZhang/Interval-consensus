% validation of interval consensus of deterministic network
function y = deterministic_net(W, step, iter, x0, limitation)
% input: W-Laplacian matrix; step-step size; iter-maximum iteration num;
% x0-init state; limitation-limitation of each node
%% iterations
L = size(x0, 1); y = zeros(L, iter); y(:, 1) = x0;
for j = 2 : iter 
    tmp = zeros(L, 1);
    for i = 1 : L
        x_sat = sat(y(:,j-1), limitation, i, L); % saturation for line i
        x_sat(i) = 0;
        tmp(i) = -W(i, i) * y(i, j-1) + W(i, :) * x_sat;
    end
    y(:, j) = y(:, j-1) + step*tmp;
    if j == 50
        y(:, j) = y(:, j) + [0.5, -1, -0.5, 1]';
    end
end

%% plot
for i = 1 : L
    plot(step:step:step*iter, y(i, :),'LineWidth',1)
    hold on; grid on
end
axis([0,20,-5.5, 5.5])
xlabel('t','FontName','Times New Roman','FontSize',10);ylabel('x_i(t)','FontName','Times New Roman','FontSize',10);
legend('Node 1', 'Node 2', 'Node 3', 'Node 4')
hold off
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