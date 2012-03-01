%% Policy iteration

function policyIteration(Fig, Policy, Discount, StateTransitions, MaxValueIterations, MaxPolicyIterations)
    for PP = 1:MaxPolicyIterations
        % Evaluate policy
        V = evaluatePolicy(Policy, StateTransitions, reward, Discount, MaxValueIterations);

        % Compute greedy policy
        NewPolicy = computeGreedyPolicy(V, StateTransitions, reward, Discount);
        if (all(Policy == NewPolicy))
            break;
        end
        Policy = NewPolicy;

        vizPolicy(Fig, V, Policy);

        % refresh;
        % pause(0.1);
    end
    fprintf('Policy Iteration: Iterations before policy convergence: %d\n', PP);
end
fprintf('Policy iteration\n');
Discount = 1;
MaxValueIterations = 1000;
MaxPolicyIterations = 1000;
policyIteration(3, StartPolicy, Discount, NormalStateTransitions, MaxValueIterations, MaxPolicyIterations);
writeFigurePDF('NormalPolicyIteration.pdf');