function [V] = evaluatePolicy(Policy, StateTransitions, Reward, Discount, MaxIterations)
    NStates = size(Policy, 1);
    V = zeros([NStates, 1]);
    for Iteration = 1:MaxIterations
        OldV = V;
        V = evaluatePolicyStep(V, Policy, StateTransitions, Reward, Discount);
        MaxDelta = max(abs(V - OldV));
        
        

    %   Vectorised, but slower :/
    %   S = (1:NStates)';
    %   A = Policy(S)';
    %   S2 = StateTransitions(sub2ind(size(StateTransitions), S, A));
    %   R = reward(S, A, S2);
    %   V2 = V(S2);
    %   NV = R + Discount * V2;
    %   MaxDelta = max(abs(V - NV));
    %   V = NV;

        if (MaxDelta < 0.001)
            break;
        end
    end
    fprintf('Iterations before value fn convergence: %d\n', Iteration);
end