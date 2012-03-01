NormalStateTransitions = @(S, A) deal(StateTransitionTable(S, A), 1);

%% Policy evaluation
function [V] = evaluatePolicyStep(V, Policy, StateTransitions, Reward, Discount)
    for S = 1:NStates
        A = Policy(S);
        [S2 Pr] = StateTransitions(S, A);
        NV = 0;
        for I = 1:size(S2, 2)
            NV = NV + Pr(I) * (Reward(S, A, S2(I)) + Discount * V(S2(I)));
        end
        V(S) = NV;
    end
end

function [V] = evaluatePolicy(Policy, StateTransitions, Reward, Discount, MaxIterations)
    V = zeros([NStates, 1]);
    for Iteration = 1:MaxIterations
        OldV = V;
        V = evaluatePolicyStep(V, Policy, StateTransitions, Reward, Discount);
        MaxDelta = max(abs(V - OldV));

        if (MaxDelta < 0.001)
            break;
        end
    end
    fprintf('Iterations before value fn convergence: %d\n', Iteration);
end

function [Policy] = computeGreedyPolicy(V, StateTransitions, Reward, Discount)
    Policy = zeros([NStates, 1]);
    for S = 1:NStates
        Q = zeros([NActions, 1]);
        for A = 1:NActions;
            [S2 Pr] = StateTransitions(S, A);
            for I = 1:size(S2, 2)
                Q(A) = Q(A) + Pr(I) * (Reward(S, A, S2(I)) + Discount * V(S2(I)));
            end
        end
        [~, A] = max(Q);
        Policy(S) = A;
    end
end

fprintf('Policy evaluation\n');
Discount = 1;
MaxIterations = 1000;
V = evaluatePolicy(StartPolicy, NormalStateTransitions, reward, Discount, MaxIterations);
Policy = computeGreedyPolicy(V, NormalStateTransitions, reward, Discount);
vizPolicy(2, V, Policy);
writeFigurePDF('PolicyEvaluation.pdf');