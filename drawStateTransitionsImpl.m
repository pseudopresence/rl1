function [] = drawStateTransitionsImpl(Arrow, StateTransitions, posFromState)
    [NStates NActions] = size(StateTransitions);
    for A = 1:NActions
        for S = 1:NStates
            P = posFromState(S);
            if (StateTransitions(S, A) ~= S)
                % TODO put action index at end...
                drawGlyphImpl(squeeze(Arrow(A,:,:,:)), P);
            end
        end
    end
end