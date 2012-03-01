%% Value iteration

function [NV] = valueIterationStep(V, StateTransitions, Reward, Discount)
    NV = zeros([NStates, 1]);
    for S = 1:NStates
        Q = zeros([NActions, 1]);
        for A = 1:NActions;
            [S2 Pr] = StateTransitions(S, A);
            for I = 1:size(S2, 2)
                Q(A) = Q(A) + Pr(I) * (Reward(S, A, S2(I)) + Discount * V(S2(I)));
            end
        end
        [V2 Dummy] = max(Q);
        NV(S) = V2;
    end
end

function valueIteration(Fig, Discount, StateTransitions, MaxPolicyIterations)
    V = zeros([NStates 1]);
    for PP = 1:MaxPolicyIterations
        % Evaluate policy
        NewV = valueIterationStep(V, StateTransitions, reward, Discount);

        % Compute greedy policy
        Policy = computeGreedyPolicy(NewV, StateTransitions, reward, Discount);

        if (all(V == NewV))
            break;
        end
        V = NewV;

        vizPolicy(Fig, V, Policy);

        % refresh;
        % pause(0.1);
    end
    fprintf('Value Iteration: Iterations before policy convergence: %d\n', PP);
end
fprintf('Value iteration\n');
Discount = 1;
MaxPolicyIterations = 1000;
valueIteration(4, Discount, NormalStateTransitions, MaxPolicyIterations);
writeFigurePDF('NormalValueIteration.pdf');