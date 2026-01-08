function [best_fitness, best_solution, fitness_history] = de_rastrigin_rand1(F_in, CR_in)
% DE/rand/1/bin - Standard Differential Evolution Algorithm
% Solves the Rastrigin problem.

    % --- 1. Problem Parameters ---
    N_DIM = 10;          % Dimensionality (n)
    LB = -5.12;          % Lower Bound
    UB = 5.12;           % Upper Bound
    
    % --- 2. DE Algorithm Parameters ---
    POP_SIZE = 50;       % Population Size (N >= 4)
    MAX_GEN = 1000;      % Maximum Generations
    
    % Check if F and CR are provided, otherwise use defaults
    if nargin < 2
        CR = 0.3;        % Default Crossover Rate
        F = 0.5;         % Default Scaling Factor
    else
        F = F_in;
        CR = CR_in;
    end
    
    % --- 3. Population Initialization ---
    Pop = LB + rand(POP_SIZE, N_DIM) * (UB - LB);
    Fitness = zeros(POP_SIZE, 1);

    % Initialize convergence history
    fitness_history = zeros(MAX_GEN, 1);
    
    for i = 1:POP_SIZE
        Fitness(i) = rastrigin_function(Pop(i, :));
    end
    
    [best_fitness, best_idx] = min(Fitness);
    best_solution = Pop(best_idx, :);
    
    % Print Header
    fprintf('DE/rand/1/bin | n=%d, N=%d, MAX_GEN=%d, F=%.2f, CR=%.2f\n', ...
            N_DIM, POP_SIZE, MAX_GEN, F, CR);
    disp('--- Optimization Started ---');
    
    % --- 4. Main Evolutionary Loop ---
    for gen = 1:MAX_GEN
        
        NewPop = zeros(POP_SIZE, N_DIM);
        NewFitness = zeros(POP_SIZE, 1);
        
        for i = 1:POP_SIZE
            Target = Pop(i, :);
            
            % 4a. Mutation (DE/rand/1)
            indices = 1:POP_SIZE;
            indices(i) = []; 
            r = indices(randperm(POP_SIZE - 1, 3)); 
            
            % Mutant Vector V
            V = Pop(r(3), :) + F * (Pop(r(2), :) - Pop(r(1), :));
            
            % Boundary check
            V(V < LB) = LB;
            V(V > UB) = UB;

            % 4b. Binomial Crossover
            Trial = Target; 
            j_rand = randi(N_DIM); 
            
            for j = 1:N_DIM
                if rand() < CR || j == j_rand
                    Trial(j) = V(j); 
                end
            end
            
            % 4c. Selection
            TrialFitness = rastrigin_function(Trial);
            
            if TrialFitness < Fitness(i)
                NewPop(i, :) = Trial;
                NewFitness(i) = TrialFitness;
            else
                NewPop(i, :) = Pop(i, :);
                NewFitness(i) = Fitness(i);
            end
        end 
        
        Pop = NewPop;
        Fitness = NewFitness;
        
        % Update Global Best
        [current_best_f, current_best_idx] = min(Fitness);
        if current_best_f < best_fitness
            best_fitness = current_best_f;
            best_solution = Pop(current_best_idx, :);
        end

        % Save History
        fitness_history(gen) = best_fitness;
        
        % --- MONITORING (PHẦN BẠN MUỐN GIỮ) ---
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