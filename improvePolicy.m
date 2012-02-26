function [Policy] = improvePolicy(StateTransitions, V)
    [NStates NActions] = size(StateTransitions);
    Policy = zeros([1, NStates]);
    for S = 1:NStates
        VA = zeros([NActions, 1]);
        for A = 1:NActions;
            S2 = StateTransitions(S, A);
            VA(A) = V(S2);
        end
        [Dummy A] = max(VA);
        Policy(S) = A;
    end
end