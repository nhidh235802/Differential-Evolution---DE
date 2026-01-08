% --- SCRIPT: COMPARE DE VARIANTS & VISUALIZE ---
clc; clear; close all;

% Settings
F_opt = 0.5;
CR_opt = 0.3;

fprintf('=== STARTING BATCH EXPERIMENT ===\n');

% 1. Standard DE
fprintf('\nRunning Standard DE (rand/1)...\n');
[~, ~, hist_std] = de_rastrigin_rand1(F_opt, CR_opt);

% 2. DE/best/1
fprintf('\nRunning DE/best/1...\n');
[~, ~, hist_best] = de_rastrigin_best1(F_opt, CR_opt);

% 3. DE/current-to-rand/1
fprintf('\nRunning DE/current-to-rand/1...\n');
[~, ~, hist_cur] = de_rastrigin_current_to_rand(F_opt, CR_opt);

% 4. jDE
fprintf('\nRunning jDE (Self-Adaptive)...\n');
[~, ~, hist_jde] = de_rastrigin_jde();

% 5. SaDE
fprintf('\nRunning SaDE (Strategy Adaptive)...\n');
[~, ~, hist_sade] = de_rastrigin_sade();


% --- VISUALIZATION ---
figure('Name', 'DE Variants Comparison', 'Color', 'w', 'Position', [100 100 1000 600]);

% Plot 1: Standard DE vs Best/1
subplot(2, 2, 1);
semilogy(hist_std, 'k--', 'LineWidth', 1.2); hold on;
semilogy(hist_best, 'r-', 'LineWidth', 1.5);
title('Exploration vs Exploitation');
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('Standard DE (rand/1)', 'DE/best/1', 'Location', 'Best');
grid on;

% Plot 2: current-to-rand
subplot(2, 2, 2);
semilogy(hist_std, 'k--', 'LineWidth', 1.2); hold on;
semilogy(hist_cur, 'b-', 'LineWidth', 1.5);
title('Current-to-Rand Strategy');
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('Standard DE', 'DE/current-to-rand/1', 'Location', 'Best');
grid on;

% Plot 3: Adaptive Variants (jDE & SaDE)
subplot(2, 2, 3);
semilogy(hist_jde, 'm-', 'LineWidth', 1.5); hold on;
semilogy(hist_sade, 'g-', 'LineWidth', 1.5);
title('Adaptive Variants');
xlabel('Generation'); ylabel('Fitness (Log Scale)');
legend('jDE', 'SaDE', 'Location', 'Best');
grid on;

% Plot 4: All Combined
subplot(2, 2, 4);
semilogy(hist_std, 'k:', 'LineWidth', 1); hold on;
semilogy(hist_best, 'r-', 'LineWidth', 1.5);
semilogy(hist_cur, 'b-', 'LineWidth', 1.5);
semilogy(hist_jde, 'm-', 'LineWidth', 1.5);
semilogy(hist_sade, 'g-', 'LineWidth', 1.5);
title('Overall Comparison');
xlabel('Generation'); ylabel('Fitness (Log Scale)');
grid on;

disp('Done! Check the figure.');