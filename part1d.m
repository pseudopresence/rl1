% Sticky wall
StickyProb = 0.4;

function [S2 Pr] = stickyStateTransitions(S, A)
    P = posFromState(S);
    X = P(1);
    if X == MapWidth
        S2 = [S, StateTransitionTable(S, A)];
        Pr = [StickyProb, 1 - StickyProb];
    else
        S2 = StateTransitionTable(S, A);
        Pr = 1;
    end
end

Discount = 1;
MaxValueIterations = 1000;
MaxPolicyIterations = 1000;
fprintf('Sticky world policy iteration\n');
policyIteration(5, StartPolicy, Discount, @stickyStateTransitions, MaxValueIterations, MaxPolicyIterations);
writeFigurePDF('StickyPolicyIteration.pdf')
fprintf('Sticky world value iteration\n');
valueIteration(6, Discount, @stickyStateTransitions, MaxPolicyIterations);
writeFigurePDF('StickyValueIteration.pdf');
StickyProb = 0.6;
fprintf('Sticky world policy iteration - p = 0.6\n');
policyIteration(7, StartPolicy, Discount, @stickyStateTransitions, MaxValueIterations, MaxPolicyIterations);
writeFigurePDF('StickyPolicyIteration6.pdf');