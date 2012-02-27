function [] = drawPolicy(ArrowGlyphs, Policy, PosFromState)
    [NStates] = size(Policy);
    
    for S = 1:NStates
        P = PosFromState(S);
        X = P(1);
        Y = P(2);
        drawAction(ArrowGlyphs, X, Y, Policy(S));
    end
end