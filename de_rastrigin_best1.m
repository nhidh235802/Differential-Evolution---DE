function [best_fitness, best_solution, fitness_history] = de_rastrigin_best1(F, CR)
% DE/best/1/bin - Mutation Strategy using the Best Vector
% Solves the Rastrigin problem.

    % --- 1. Problem Parameters ---
    N_DIM = 10;
    LB = -5.12; UB = 5.12;
    
    % --- 2. Algorithm Parameters ---
    POP_SIZE = 50;
    MAX_GEN = 1000;
    if nargin < 2, F = 0.5; CR = 0.3; end % Default defaults

    % --- 3. Initialization ---
    Pop = LB + rand(POP_SIZE, N_DIM) * (UB - LB);
    Fitness = zeros(POP_SIZE, 1);
    fitness_history = zeros(MAX_GEN, 1);
    
    for i = 1:POP_SIZE, Fitness(i) = rastrigin_function(Pop(i, :)); end
    [best_fitness, ~] = min(Fitness);

    fprintf('DE/best/1/bin | n=%d, N=%d, MAX_GEN=%d\n', N_DIM, POP_SIZE, MAX_GEN);
    disp('--- Optimization Started ---');
    
    % --- 4. Main Loop ---
    for gen = 1:MAX_GEN
        NewPop = zeros(POP_SIZE, N_DIM);
        NewFitness = zeros(POP_SIZE, 1);
        
        [~, best_idx] = min(Fitness);
        I_best = Pop(best_idx, :); 

        for i = 1:POP_SIZE
            % Mutation: DE/best/1
            indices = 1:POP_SIZE; indices([i, best_idx]) = [];
            r = indices(randperm(length(indices), 2));
            V = I_best + F * (Pop(r(2), :) - Pop(r(1), :));
            V(V < LB) = LB; V(V > UB) = UB;

            % Crossover & Selection
            Trial = Pop(i, :); j_rand = randi(N_DIM);
            for j = 1:N_DIM
                if rand() < CR || j == j_rand, Trial(j) = V(j); end
            end
            
            TrialFitness = rastrigin_function(Trial);
            if TrialFitness < Fitness(i)
                NewPop(i, :) = Trial; NewFitness(i) = TrialFitness;
            else
                NewPop(i, :) = Pop(i, :); NewFitness(i) = Fitness(i);
            end
        end 
        
        Pop = NewPop; Fitness = NewFitness;
        [best_fitness, best_idx] = min(Fitness);
        best_solution = Pop(best_idx, :);
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