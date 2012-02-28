function [V] = evaluatePolicyStep(V, Policy, NStates, StateTransitions, Reward, Discount)
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