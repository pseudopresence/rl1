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
MaxEpisodes = 25000000;
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
    Rs = zeros([1 NCandidates]);
    
    SortedSoFar = zeros([1 NCandidates]);
    
    for K = 1:NCandidates
        % Rank of the candidate among those seen so far
        R = K;
        if K > 1
            for I = (K-1):-1:1
                if SortedSoFar(I) < C(K)
                    SortedSoFar(I + 1) = SortedSoFar(I);
                    R = R - 1;
                else
                    break;
                end
            end
        end
        SortedSoFar(R) = C(K);
        
        if (K == NCandidates)
            Action = 2;
        elseif (rand(1) < Epsilon)
            Action = (rand(1) > 0.5) + 1;
        else
            Action = Policy(K, R);
        end
        Rs(K) = R;
        if Action == 2
            break;
        end
    end
    MaxK = K;
    Reward = C(K);
    for K = 1:MaxK
        A = (K == MaxK) + 1;
        R = Rs(K);
                
        NV = VisitCount(K, R, A) + 1;
        VisitCount(K, R, A) = NV;
        NT = TotalReturn(K, R, A) + Reward;
        TotalReturn(K, R, A) = NT;
        Q(K, R, A) = NT / NV;
        
        Policy(K, R) = (Q(K, R, 1) < Q(K, R, 2)) + 1;
    end
    
    if (mod(Episode, 10000) == 0)
        fprintf('Episode %d (%03d%%)\n', Episode, floor(100*Episode/MaxEpisodes));
    end
end
for K = 1:NCandidates
    for R = (K+1):NCandidates
        Policy(K, R) = 0;
    end
end
toc;
figure;
imagesc(Policy');
axis xy;
axis square;
xlabel('Step');
ylabel('Rank');
colormap('gray');
% writeFigurePDF('SecretaryMDPPolicy.pdf');
figure;
imagesc(Q(:,:,1)');
axis xy;
axis square;
xlabel('Step');
ylabel('Rank');
colormap('gray');
% writeFigurePDF('SecretaryMDPQFunction.pdf');
figure;
[VG, Dummy] = max(Q, [], 3);
VE = 0.5 * sum(Q, 3);
V = (1-Epsilon) * VG + Epsilon * VE;
imagesc(V');
axis xy;
axis square;
xlabel('Step');
ylabel('Rank');
colormap('gray');
% writeFigurePDF('SecretaryMDPVFunction.pdf');
end