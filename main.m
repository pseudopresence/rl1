clc;
clear all;
close all;

%% Setup
% Action representation: Idx mapped to dX, dY by this table
Actions = [
    +1  0; % 1 E >
     0 -1; % 2 S V
    -1  0; % 3 W < 
     0 +1; % 4 N ^
]';

Rot90 = [
     0 +1;
    -1  0
];

MapWidth = 8;
MapHeight = 8;

stateFromPos = @(P) (P(1) - 1) + MapWidth * (P(2) - 1) + 1;
posFromState = @(S) [mod((S - 1),MapWidth) + 1, floor((S - 1)/MapWidth) + 1];

%% Walls
% TODO 'vertical' and 'horizontal' are the wrong way around
% Vertical wall representation: Y, StartX, EndX
Walls_V = [
    0.5, 0.5, 8.5;
    1.5, 0.5, 1.5;
    1.5, 7.5, 8.5;
    5.5, 3.5, 5.5;
    6.5, 2.5, 6.5;
    8.5, 0.5, 8.5
];

% Horizontal wall representation: X, StartY, EndY
Walls_H = [
    0.5, 0.5, 8.5;
    2.5, 4.5, 6.5;
    3.5, 3.5, 5.5;
    4.5, 2.5, 4.5;
    5.5, 3.5, 5.5;
    6.5, 4.5, 6.5;
    8.5, 0.5, 8.5
];

drawWalls = @() drawWalls(Walls_V, Walls_H);

figure;
axis([0.5, 8.5, 0.5, 8.5]);
axis square;
drawWalls();

% Compute state transition matrix from walls

Arrow(1, 1, 1, :) = [0.25; 0];
Arrow(1, 1, 2, :) = [0.75; 0];
Arrow(1, 2, 1, :) = [0.625; -0.125];
Arrow(1, 2, 2, :) = [0.75; 0];
Arrow(1, 3, 1, :) = [0.625; +0.125];
Arrow(1, 3, 2, :) = [0.75; 0];
% Rotate for other directions
for A = 2:4
    for L = 1:3
        for I = 1:2
            Arrow(A,L,I,:) = Rot90^(A-1) * squeeze(Arrow(1,L,I,:));
        end
    end
end
% [State x Action] -> State
StateTransitions = zeros([MapWidth * MapHeight, size(Actions, 2)]);

for A = 1:size(Actions, 2)
    for S = 1:size(StateTransitions, 1)
        P = posFromState(S);
        
        X = P(1);
        Y = P(2);
        NP = Actions(:,A)' + P;
        MoveOK = 1;
        
        for W = 1:size(Walls_V, 1)
            WS = [Walls_V(W, 2) Walls_V(W, 1)];
            WE = [Walls_V(W, 3) Walls_V(W, 1)];
            MoveOK = MoveOK & ~testSegmentSegment(P, NP, WS, WE);
        end
        
        for W = 1:size(Walls_H, 1)
            WS = [Walls_H(W, 1) Walls_H(W, 2)];
            WE = [Walls_H(W, 1) Walls_H(W, 3)];
            MoveOK = MoveOK & ~testSegmentSegment(P, NP, WS, WE);
        end
        if (MoveOK)
            StateTransitions(S, A) = stateFromPos(NP);
            drawArrow(Arrow, P, A);
        else
            StateTransitions(S, A) = S;
        end
    end
end

%% TODO - finish starting (non-optimal) policy on paper, make into table

% Policy representation: [State] -> Action
% Goal state action set to 0 so we get an error trying to take an action
% from the goal state
StartPolicy = [
    3 4 4 4 4 4 4 1 ...
    3 4 4 3 3 3 4 1 ...
    3 4 4 2 4 1 4 1 ...
    3 3 4 2 4 2 4 1 ...
    3 2 4 2 1 2 4 1 ...
    3 2 3 3 3 2 3 4 ...
    3 2 1 1 3 3 2 4 ...
    3 2 1 1 3 3 2 0
];

% Glyphs for rendering policies
% TODO make X/Y component the last, the remove the squeeze()
% TODO remove the transpose
% TODO generate with rotation matrix
% 0 G X
ActionGlyphs(1, 1, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 1, :, :) = [-1 +1; +1 -1]';
% 1 E >
ActionGlyphs(1, 2, :, :) = [+1 -1; +1 -1]';
ActionGlyphs(2, 2, :, :) = [+1  0; -1  0]';
% 2 S V
ActionGlyphs(1, 3, :, :) = [-1  0; +1  0]';
ActionGlyphs(2, 3, :, :) = [+1 -1; +1 -1]';
% 3 W < 
ActionGlyphs(1, 4, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 4, :, :) = [+1  0; -1  0]';
% 4 N ^
ActionGlyphs(1, 5, :, :) = [-1  0; +1  0]';
ActionGlyphs(2, 5, :, :) = [-1 +1; -1 +1]';
% Rescale
ActionGlyphs = 0.25 * ActionGlyphs;

drawAction = @(X,Y,A) drawAction(ActionGlyphs, X, Y, A);

for X = 1:MapWidth;
    for Y = 1:MapHeight;
        S = stateFromPos([X, Y]);
        drawAction(X, Y, StartPolicy(S));
    end
end



%% TODO - visualisation for grid world with walls
%% TODO - visualisation for policies, showing arrow for direction
%% TODO - visualisation for state-value function
%% TODO - implement state transition probs PP(a, s, s') as a function that
%% PP(s, a) -> [States, Probs]; a list of non-zero next states and their
%% probabilities? Or PP(s, a, rnd) -> new state at random according to
%% distribution

%% Part I - gridworld, dynamic programming

%% Part II - secretary problem, MC, TD (Q-learning)