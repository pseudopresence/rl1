function [V] = evaluatePolicy(Policy, StateTransitions, Reward, Discount, MaxIterations)
    NStates = size(Policy, 1);
    V = zeros([NStates, 1]);
    for Iteration = 1:MaxIterations
        MaxDelta = 0;
        for S = 1:NStates
            A = Policy(S);
            S2 = StateTransitions(S, A);
            NV = Reward(S, A, S2) + Discount * V(S2);

            MaxDelta = max(MaxDelta, abs(V(S) - NV));
            V(S) = NV;
        end

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