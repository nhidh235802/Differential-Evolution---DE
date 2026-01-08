function [best_fitness, best_solution, fitness_history] = de_rastrigin_sade()
% SaDE (Self-adaptive Differential Evolution) - Simplified
% Adapts between two strategies: 
% 1. DE/rand/1/bin
% 2. DE/current-to-best/1/bin (modified for simplicity)

    % --- Parameters ---
    N_DIM = 10; LB = -5.12; UB = 5.12;
    POP_SIZE = 50; MAX_GEN = 1000;
    LP = 50; % Learning Period (Generations)

    % Strategy Probability (initially 50/50)
    p1 = 0.5; % Prob for Strategy 1
    ns1 = 0; nf1 = 0; % Success/Failure counts for Strat 1
    ns2 = 0; nf2 = 0; % Success/Failure counts for Strat 2

    % --- Initialization ---
    Pop = LB + rand(POP_SIZE, N_DIM) * (UB - LB);
    Fitness = zeros(POP_SIZE, 1);
    fitness_history = zeros(MAX_GEN, 1);
    
    for i = 1:POP_SIZE, Fitness(i) = rastrigin_function(Pop(i, :)); end
    [best_fitness, best_idx] = min(Fitness);
    best_solution = Pop(best_idx, :);

    fprintf('SaDE (Strategy Adaptive) | n=%d, N=%d, MAX_GEN=%d\n', N_DIM, POP_SIZE, MAX_GEN);
    disp('--- Optimization Started ---');

    for gen = 1:MAX_GEN
        NewPop = zeros(POP_SIZE, N_DIM); NewFitness = zeros(POP_SIZE, 1);
        [~, best_idx] = min(Fitness); GlobalBest = Pop(best_idx, :);

        for i = 1:POP_SIZE
            % Adapt F and CR (Normal Distribution approximation)
            F_i = 0.5 + 0.3*randn(); % Mean 0.5, Std 0.3
            CR_i = 0.5 + 0.1*randn(); % Mean 0.5, Std 0.1
            CR_i = max(0, min(1, CR_i)); % Clip CR

            % Select Strategy
            strategy = 1;
            if rand() > p1, strategy = 2; end

            Target = Pop(i, :);
            indices = 1:POP_SIZE; indices(i) = [];
            
            % Mutation & Crossover based on Strategy
            if strategy == 1 % Strategy 1: DE/rand/1/bin
                r = indices(randperm(length(indices), 3));
                V = Pop(r(1), :) + F_i * (Pop(r(2), :) - Pop(r(3), :));
            else % Strategy 2: DE/current-to-best/1 (No Binomial Crossover usually, but we use bin here for consistency)
                r = indices(randperm(length(indices), 2));
                V = Target + F_i * (GlobalBest - Target) + F_i * (Pop(r(1), :) - Pop(r(2), :));
            end
            
            % Boundary & Binomial Crossover
            V(V < LB) = LB; V(V > UB) = UB;
            Trial = Target; j_rand = randi(N_DIM);
            for j = 1:N_DIM
                if rand() < CR_i || j == j_rand, Trial(j) = V(j); end
            end

            % Selection & Learning
            TrialFitness = rastrigin_function(Trial);
            if TrialFitness < Fitness(i)
                NewPop(i, :) = Trial; NewFitness(i) = TrialFitness;
                if strategy == 1, ns1 = ns1 + 1; else, ns2 = ns2 + 1; end
            else
                NewPop(i, :) = Pop(i, :); NewFitness(i) = Fitness(i);
                if strategy == 1, nf1 = nf1 + 1; else, nf2 = nf2 + 1; end
            end
        end
        
        Pop = NewPop; Fitness = NewFitness;
        [best_fitness, best_idx] = min(Fitness);
        best_solution = Pop(best_idx, :);
        fitness_history(gen) = best_fitness;

        % Update Strategy Probabilities after Learning Period
        if mod(gen, LP) == 0
            S1 = ns1 / (ns1 + nf1 + 1e-10);
            S2 = ns2 / (ns2 + nf2 + 1e-10);
            p1 = S1 / (S1 + S2 + 1e-10);
            % Reset counts
            ns1 = 0; nf1 = 0; ns2 = 0; nf2 = 0;
        end
        
        if mod(gen, 100) == 0
            fprintf('Generation %d: Best Fitness = %.6f (p1=%.2f)\n', gen, best_fitness, p1);
        end
    end
    disp('--- Optimization Finished ---');
    fprintf('Final Fitness Value (f(x)): %.8f\n', best_fitness);
    fprintf('Optimal Vector (x): (');
    fprintf('%.4f, ', best_solution(1:end-1));
    fprintf('%.4f)\n', best_solution(end));
end