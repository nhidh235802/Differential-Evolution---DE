% --- SCRIPT: PLOT LINEAR CONVERGENCE (EARLY PHASE) ---
% Mục tiêu: So sánh tốc độ giảm Fitness ở giai đoạn đầu (từ 100 về 0)
clc; clear; close all;

% 1. Cấu hình & Chạy lại dữ liệu (hoặc load từ workspace nếu đã có)
F_opt = 0.5; CR_opt = 0.3;
fprintf('Running algorithms to capture early behavior...\n');
[~, ~, hist_std] = de_rastrigin_rand1(F_opt, CR_opt);
[~, ~, hist_best] = de_rastrigin_best1(F_opt, CR_opt);
[~, ~, hist_cur] = de_rastrigin_current_to_rand(F_opt, CR_opt);
[~, ~, hist_jde] = de_rastrigin_jde();
[~, ~, hist_sade] = de_rastrigin_sade();

% 2. Vẽ biểu đồ Linear Scale
figure('Name', 'Early Convergence Phase', 'Color', 'w', 'Position', [100 100 800 600]);

% Vẽ các đường
plot(hist_std, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Standard DE (Baseline)'); hold on;
plot(hist_best, 'r-', 'LineWidth', 1.5, 'DisplayName', 'DE/best/1');
plot(hist_cur, 'b-', 'LineWidth', 1.5, 'DisplayName', 'DE/curr-to-rand');
plot(hist_jde, 'm-', 'LineWidth', 2.0, 'DisplayName', 'jDE (Adaptive)');
plot(hist_sade, 'g-', 'LineWidth', 2.0, 'DisplayName', 'SaDE (Adaptive)');

% 3. Tinh chỉnh trục để Zoom vào vùng quan trọng
% Chỉ lấy trục Y từ 0 đến 100 (hoặc 80 tùy dữ liệu max của bạn)
ylim([0, 100]); 
xlim([0, 1000]); 

% 4. Trang trí
grid on;
title('Early Convergence Behavior (Linear Scale)', 'FontSize', 14);
xlabel('Generation', 'FontSize', 12);
ylabel('Fitness Value', 'FontSize', 12);
legend('show', 'Location', 'NorthEast', 'FontSize', 11);

% Thêm chú thích trực tiếp lên hình
text(20, 80, 'Initial Search Space', 'Color', [0.5 0.5 0.5], 'FontSize', 10);
text(150, 5, 'Convergence Zone', 'Color', 'blue', 'FontSize', 10);

disp('Done! Linear plot generated.');