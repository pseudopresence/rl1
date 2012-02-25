%% Walls - StartX, StartY, EndX, EndY
% Walls_V - Y, StartX, EndX
Walls_V = [
    0.5, 0.5, 8.5;
    1.5, 0.5, 1.5;
    1.5, 7.5, 8.5;
    5.5, 3.5, 5.5;
    6.5, 2.5, 6.5;
    8.5, 0.5, 8.5
];

% Walls_H - X, StartY, EndY
Walls_H = [
    0.5, 0.5, 8.5;
    2.5, 4.5, 6.5;
    3.5, 3.5, 5.5;
    4.5, 2.5, 4.5;
    5.5, 3.5, 5.5;
    6.5, 4.5, 6.5;
    8.5, 0.5, 8.5
];

figure;
hold on;
axis([0.5, 8.5, 0.5, 8.5]);
axis square;
for i = 1:size(Walls_V, 1)
    Y      = Walls_V(i,1);
    StartX = Walls_V(i,2);
    EndX   = Walls_V(i,3);
    
    line([StartX EndX], [Y Y], 'Color', 'red');
end
for i = 1:size(Walls_H, 1)
    X      = Walls_H(i,1);
    StartY = Walls_H(i,2);
    EndY   = Walls_H(i,3);
    
    line([X X], [StartY EndY], 'Color', 'red');
end
hold off;


%% TODO - finish starting (non-optimal) policy on paper, make into table


%% TODO - visualisation for grid world with walls
%% TODO - visualisation for policies, showing arrow for direction
%% TODO - visualisation for state-value function
%% TODO - implement state transition probs PP(a, s, s') as a function that
%% PP(s, a) -> [States, Probs]; a list of non-zero next states and their
%% probabilities? Or PP(s, a, rnd) -> new state at random according to
%% distribution

%% Part I - gridworld, dynamic programming

%% Part II - secretary problem, MC, TD (Q-learning)