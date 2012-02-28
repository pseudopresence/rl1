function [Policy] = improvePolicy(V, NStates, NActions, StateTransitions, Reward, Discount)
    Policy = zeros([NStates, 1]);
    for S = 1:NStates
        Q = zeros([NActions, 1]);
        for A = 1:NActions;
            [S2 Pr] = StateTransitions(S, A);
            for I = 1:size(S2, 2)
                Q(A) = Q(A) + Pr(I) * (Reward(S, A, S2(I)) + Discount * V(S2(I)));
            end
        end
        [Dummy A] = max(Q);
        Policy(S) = A;
    end
end