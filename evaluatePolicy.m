function [V] = evaluatePolicy(Policy, StateTransitions, Reward, Discount, MaxIterations)
    NStates = size(Policy, 1);
    V = zeros([NStates, 1]);
    for Iteration = 1:MaxIterations
        OldV = V;
        V = evaluatePolicyStep(V, Policy, NStates, StateTransitions, Reward, Discount);
        MaxDelta = max(abs(V - OldV));

        if (MaxDelta < 0.001)
            break;
        end
    end
    fprintf('Iterations before value fn convergence: %d\n', Iteration);
end