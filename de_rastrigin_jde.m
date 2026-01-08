function [best_fitness, best_solution, fitness_history] = de_rastrigin_jde()
% jDE (Self-Adaptive DE) Algorithm
% Solves the Rastrigin problem.

    % --- Parameters ---
    N_DIM = 10; LB = -5.12; UB = 5.12;
    POP_SIZE = 50; MAX_GEN = 1000;
    TAU1 = 0.1; TAU2 = 0.1; F_L = 0.1; F_U = 1.0;

    % --- Initialization ---
    Pop = zeros(POP_SIZE, N_DIM + 2); % [Params | F | CR]
    Fitness = zeros(POP_SIZE, 1);
    fitness_history = zeros(MAX_GEN, 1);
    
    range = UB - LB;
    for i = 1:POP_SIZE
        Pop(i, 1:N_DIM) = LB + rand(1, N_DIM) * range;
        Pop(i, N_DIM + 1) = F_L + rand() * (F_U - F_L); % Init F
        Pop(i, N_DIM + 2) = rand();                      % Init CR
        Fitness(i) = rastrigin_function(Pop(i, 1:N_DIM));
    end
    [best_fitness, best_idx] = min(Fitness);
    best_solution = Pop(best_idx, 1:N_DIM);

    fprintf('jDE (Self-Adaptive) | n=%d, N=%d, MAX_GEN=%d\n', N_DIM, POP_SIZE, MAX_GEN);
    disp('--- Optimization Started ---');

    for gen = 1:MAX_GEN
        NewPop = zeros(POP_SIZE, N_DIM + 2); NewFitness = zeros(POP_SIZE, 1);
        
        for i = 1:POP_SIZE
            Target = Pop(i, :);
            F_i = Target(N_DIM+1); CR_i = Target(N_DIM+2);
            
            % Self-adaptation
            if rand() < TAU1, F_i = F_L + rand() * (F_U - F_L); end
            if rand() < TAU2, CR_i = rand(); end
            
            % Mutation (rand/1) using adapted F
            indices = 1:POP_SIZE; indices(i) = [];
            r = indices(randperm(length(indices), 3));
            V = Pop(r(3), 1:N_DIM) + F_i * (Pop(r(2), 1:N_DIM) - Pop(r(1), 1:N_DIM));
            V(V < LB) = LB; V(V > UB) = UB;

            % Crossover using adapted CR
            Trial = Target; 
            j_rand = randi(N_DIM);
            for j = 1:N_DIM
                if rand() < CR_i || j == j_rand, Trial(j) = V(j); end
            end
            Trial(N_DIM+1) = F_i; Trial(N_DIM+2) = CR_i;
            
            % Selection
            TrialFitness = rastrigin_function(Trial(1:N_DIM));
            if TrialFitness < Fitness(i)
                NewPop(i, :) = Trial; NewFitness(i) = TrialFitness;
            else
                NewPop(i, :) = Pop(i, :); NewFitness(i) = Fitness(i);
            end
        end
        
        Pop = NewPop; Fitness = NewFitness;
        [best_fitness, best_idx] = min(Fitness);
        best_solution = Pop(best_idx, 1:N_DIM);
        fitness_history(gen) = best_fitness;
        
        if mod(gen, 100) == 0
            fprintf('Generation %d: Best Fitness = %.6f\n', gen, best_fitness);
        end
    end
    disp('--- Optimization Finished ---');
    fprintf('Final Fitness Value (f(x)): %.8f\n', best_fitness);
    fprintf('Optimal Vector (x): (');
    fprintf('%.4f, ', best_solution(1:end-1));
    fprintf('%.4f)\n', best_solution(end));
end