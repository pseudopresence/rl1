function secretary_MDP_MC()

% Formulation as a Markov Decision Process
% Actions: Accept, Reject. On 30th step can only Accept.
% Represented as 2, 1.
% States: On step K, we have rejected the first K-1 applicants, and we
% observe the ranking of the Nth candidate relative to them. There are K
% such possible rankings: they can be in position 1 to K. The rankings of
% the rejected candidates among themselves is irrelevant.

% Terminal States: All states after Accept action.

% Total number of states is 1 + 2 + ... + 30 + Terminal state
% = 1/2 N(N + 1) + 1 = 466.

% Reward: We assign to each candidate a random value 0-1 according to which
% they are ranked. The reward is the value of the accepted candidate on
% entering a terminal state, 0 otherwise.

NCandidates = 30;

% We will represent the state by a pair of integers, K in the range 1:N and
% R in the range 1:K.

% For the on-policy monte-carlo implementation we will learn the Q(S, A)
% function using an e-greedy strategy.

Epsilon = 0.1;

Q = zeros([NCandidates, NCandidates, 2]);
Policy = zeros([NCandidates, NCandidates]);
TotalReturn = zeros([NCandidates, NCandidates, 2]);
VisitCount = zeros([NCandidates, NCandidates, 2]);

tic;
MaxEpisodes = 10000;
for Episode = 1:MaxEpisodes
    % Each episode, we will generate 30 random candidate values
    % Without loss of generality we will interview them in order 1-N

    C = rand([NCandidates, 1]);
    
    % We always visit the starting state [1,1]. 
    % We always finish in the terminal state.
    % In each episode we go through states [1, 1], [2, R_2], ... [K, R_K]
    % before hitting the terminal state; so we need only store the sequence
    % of rankings after the first state to determine all the visited
    % states.
    % Similarly we know the sequence of actions taken based on the length
    % of this sequence.
    Rs = [];
    
    for K = 1:NCandidates
        % Rank of the candidate among those seen so far
        [Dummy I] = sort(C(1:K));
        R = I(K);
        if (K == NCandidates)
            Action = 2;
        elseif (rand(1) < Epsilon)
            Action = (rand(1) > 0.5) + 1;
        else
            Action = Policy(K, R);
        end
        Rs = [Rs R];
        if Action == 2
            break;
        end
    end
    
    Reward = C(K);
    for K = 1:size(Rs, 2)
        % disp([K Rs(K)]);
        % pause(1);
        A = (K == size(Rs, 2)) + 1;
        VisitCount(K, Rs(K), A) = VisitCount(K, Rs(K), A) + 1;
        TotalReturn(K, Rs(K), A) = TotalReturn(K, Rs(K), A) + Reward;
    end
    
    OldQ = Q;
    for K = 1:(NCandidates - 1)
        for R = 1:K
            for A = 1:2
                Q(K, R, A) = TotalReturn(K, R, A) / max(VisitCount(K, R, A), 1);
            end
        end
    end
    [Dummy, Policy] = max(Q, [], 3);
    
    if max(max(max(abs(Q - OldQ),[],1),[],2),[],3) < 0.00001
    %    break;
    end
    
%    disp(Episode);
end
fprintf('Episodes to convergence: %d\n', Episode);
toc;
figure;
imagesc(Policy);
figure;
imagesc(Q(:,:,1));
figure;
imagesc(Q(:,:,2));
end