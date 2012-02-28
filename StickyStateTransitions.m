function [S2 Pr] = StickyStateTransitions(posFromState, MapWidth, StickyProb, StateTransitions, S, A)
    P = posFromState(S);
    X = P(1);
    if X == MapWidth
        S2 = [S, StateTransitions(S, A)];
        Pr = [StickyProb, 1 - StickyProb];
    else
        S2 = StateTransitions(S, A);
        Pr = 1;
    end
end