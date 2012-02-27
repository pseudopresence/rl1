function [NV] = valueIteration(V, StateTransitions, Reward, Discount)
    [NStates NActions] = size(StateTransitions);
    NV = zeros([NStates, 1]);
    for S = 1:NStates
        Q = zeros([NActions, 1]);
        for A = 1:NActions;
            S2 = StateTransitions(S, A);
            Q(A) = Reward(S, A, S2) + Discount * V(S2);
        end
        [V2 Dummy] = max(Q);
        NV(S) = V2;
    end
end