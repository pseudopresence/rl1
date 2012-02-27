function [V] = evaluatePolicyStep(V, Policy, StateTransitions, Reward, Discount)
    [NStates NActions] = size(StateTransitions);
    for S = 1:NStates
        A = Policy(S);
        S2 = StateTransitions(S, A);
        NV = Reward(S, A, S2) + Discount * V(S2);
        V(S) = NV;
    end
end