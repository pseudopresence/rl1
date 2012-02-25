clc;
clear all;
close all;

%% Walls - StartX, StartY, EndX, EndY
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

% TODO - compute state transition matrix from walls


%% TODO - finish starting (non-optimal) policy on paper, make into table

% Policy representation: [State] -> Action
% Goal state action set to 0 so we get an error trying to take an action
% from the goal state
StartPolicy = [
    4 1 1 1 1 1 1 3 ...
    4 1 1 4 4 4 1 3 ...
    4 1 1 2 1 3 1 3 ...
    4 4 1 2 1 2 1 3 ...
    4 2 1 2 3 2 1 3 ...
    4 2 4 4 4 2 4 1 ...
    4 2 3 3 4 4 2 1 ...
    4 2 3 3 4 4 2 0
];

% Glyphs for rendering policies
ActionGlyphs(1, 1, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(1, 2, :, :) = [-1  0; +1  0]';
ActionGlyphs(1, 3, :, :) = [-1  0; +1  0]';
ActionGlyphs(1, 4, :, :) = [+1 -1; +1 -1]';
ActionGlyphs(1, 5, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 1, :, :) = [-1 +1; +1 -1]';
ActionGlyphs(2, 2, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 3, :, :) = [+1 -1; +1 -1]';
ActionGlyphs(2, 4, :, :) = [+1  0; -1  0]';
ActionGlyphs(2, 5, :, :) = [+1  0; -1  0]';

drawAction = @(X,Y,A) drawAction(ActionGlyphs, X, Y, A);

MapWidth = 8;
MapHeight = 8;
stateFromPos = @(P) (P(1) - 1) + MapWidth * (P(2) - 1) + 1;
posFromState = @(S) [mod((S - 1),MapWidth) + 1, floor((S - 1)/MapWidth) + 1];

for X = 1:MapWidth;
    for Y = 1:MapHeight;
        S = stateFromPos([X, Y]);
        drawAction(X, Y, StartPolicy(S));
    end
end

% Action representation: Idx mapped to dX, dY by this table
Actions = [
     0 +1; % N
     0 -1; % S
    +1  0; % W
    -1  0; % E
]';

%% TODO - visualisation for grid world with walls
%% TODO - visualisation for policies, showing arrow for direction
%% TODO - visualisation for state-value function
%% TODO - implement state transition probs PP(a, s, s') as a function that
%% PP(s, a) -> [States, Probs]; a list of non-zero next states and their
%% probabilities? Or PP(s, a, rnd) -> new state at random according to
%% distribution

%% Part I - gridworld, dynamic programming

%% Part II - secretary problem, MC, TD (Q-learning)