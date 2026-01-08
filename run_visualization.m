% --- Script: Run DE and Visualize Results ---
clc; clear; close all;

% Case 1: Chạy với tham số "xấu" (F=0.8, CR=0.9) như trong báo cáo
fprintf('\n=== RUNNING CASE 1: Premature Convergence (F=0.8, CR=0.9) ===\n');
[best_f1, sol1, history1] = de_rastrigin_rand1(0.8, 0.9);

% Case 2: Chạy với tham số "tốt" (F=0.5, CR=0.3)
fprintf('\n=== RUNNING CASE 2: Optimal Convergence (F=0.5, CR=0.3) ===\n');
[best_f2, sol2, history2] = de_rastrigin_rand1(0.5, 0.3);

% --- VẼ BIỂU ĐỒ ---
figure('Name', 'Convergence Comparison', 'Color', 'w', 'Position', [100 100 800 500]);

% Dùng semilogy để nhìn rõ hơn khi giá trị về gần 0
semilogy(1:length(history1), history1, 'r-', 'LineWidth', 1.5, 'DisplayName', 'F=0.8, CR=0.9 (Premature)');
hold on;
semilogy(1:length(history2), history2, 'b-', 'LineWidth', 1.5, 'DisplayName', 'F=0.5, CR=0.3 (Optimal)');

grid on;
xlabel('Generation', 'FontSize', 12);
ylabel('Best Fitness Value (Log Scale)', 'FontSize', 12);
title('Comparison of Convergence Performance', 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'northeast', 'FontSize', 11);

% Thêm text chú thích vào đồ thị
text(400, 10, 'Trapped in Local Optima', 'Color', 'red', 'FontSize', 10);
text(600, 1e-5, 'Converged to Global Optima', 'Color', 'blue', 'FontSize', 10);