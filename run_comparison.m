% --- SCRIPT: COMPARE DE VARIANTS & VISUALIZE ---
% Mục tiêu: So sánh các biến thể với "Strong Baseline" (Standard DE 0.5/0.3)
clc; clear; close all;

% Cấu hình Baseline (Đã tìm ra ở Section 6.2)
F_opt = 0.5;
CR_opt = 0.3;

fprintf('=== STARTING COMPARISON EXPERIMENT ===\n');

% 1. Standard DE (BASELINE - Phiên bản tốt nhất)
fprintf('1. Running Standard DE (Baseline: F=0.5, CR=0.3)...\n');
[~, ~, hist_std] = de_rastrigin_rand1(F_opt, CR_opt);

% 2. DE/best/1 (Dùng cùng F, CR để so sánh chiến lược đột biến)
fprintf('2. Running DE/best/1 (Static)...\n');
[~, ~, hist_best] = de_rastrigin_best1(F_opt, CR_opt);

% 3. DE/current-to-rand/1
fprintf('3. Running DE/current-to-rand/1 (Static)...\n');
[~, ~, hist_cur] = de_rastrigin_current_to_rand(F_opt, CR_opt);

% 4. jDE (Tự thích nghi - Không cần F, CR input)
fprintf('4. Running jDE (Self-Adaptive)...\n');
[~, ~, hist_jde] = de_rastrigin_jde();

% 5. SaDE (Tự thích nghi chiến lược)
fprintf('5. Running SaDE (Strategy Adaptive)...\n');
[~, ~, hist_sade] = de_rastrigin_sade();


% --- VẼ ĐỒ THỊ SO SÁNH (LOG SCALE) ---
figure('Name', 'Comparison with Strong Baseline', 'Color', 'w', 'Position', [100 100 1200 600]);

% Layout: 1 hàng 3 cột
% Cột 1: So sánh nhóm Cố định (Static)
subplot(1, 3, 1);
semilogy(hist_std, 'k--', 'LineWidth', 1.5); hold on; % Baseline nét đứt
semilogy(hist_best, 'r-', 'LineWidth', 1.5);
semilogy(hist_cur, 'b-', 'LineWidth', 1.5);
title('Impact of Mutation Strategy', 'FontSize', 11);
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('Standard DE (Baseline)', 'DE/best/1', 'DE/curr-to-rand', 'Location', 'SouthWest');
grid on; axis tight;

% Cột 2: So sánh nhóm Tự thích nghi (Adaptive)
subplot(1, 3, 2);
semilogy(hist_std, 'k--', 'LineWidth', 1.5); hold on; % Baseline nét đứt
semilogy(hist_jde, 'm-', 'LineWidth', 1.5);
semilogy(hist_sade, 'g-', 'LineWidth', 1.5);
title('Manual Tuning vs Self-Adaptation', 'FontSize', 11);
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('Standard DE (Baseline)', 'jDE', 'SaDE', 'Location', 'SouthWest');
grid on; axis tight;

% Cột 3: Tổng hợp tất cả (So tốc độ hội tụ)
subplot(1, 3, 3);
semilogy(hist_std, 'k:', 'LineWidth', 1); hold on;
semilogy(hist_best, 'r-', 'LineWidth', 1);
semilogy(hist_cur, 'b-', 'LineWidth', 1);
semilogy(hist_jde, 'm-', 'LineWidth', 2); % Làm nổi bật Adaptive
semilogy(hist_sade, 'g-', 'LineWidth', 2); % Làm nổi bật Adaptive
title('Convergence Speed Comparison', 'FontSize', 11);
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('Standard', 'Best/1', 'Curr-to-rand', 'jDE', 'SaDE', 'Location', 'SouthWest');
grid on; axis tight;

disp('Done! Baseline is marked as black dashed line.');