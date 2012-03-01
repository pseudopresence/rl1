%% World Setup

Rot90 = [
     0 +1;
    -1  0
];

% Action representation: Idx mapped to dX, dY by this table

Actions = [
    +1  0; % 1 E >
     0 -1; % 2 S V
    -1  0; % 3 W <
     0 +1; % 4 N ^
];
NActions = size(Actions, 1);

MapWidth = 8;
MapHeight = 8;
MapSize = [MapWidth MapHeight];
NStates = prod(MapSize);
GoalState = NStates;

stateFromPos = @(P) (P(1) - 1) + MapWidth * (P(2) - 1) + 1;
posFromState = @(S) [mod((S - 1),MapWidth) + 1, floor((S - 1)/MapWidth) + 1];


%% Walls

% Horizontal wall representation: Y, StartX, EndX
Walls_H = [
    0.5, 0.5, 8.5;
    1.5, 0.5, 1.5;
    1.5, 7.5, 8.5;
    5.5, 3.5, 5.5;
    6.5, 2.5, 6.5;
    8.5, 0.5, 8.5
];

% Vertical wall representation: X, StartY, EndY
Walls_V = [
    0.5, 0.5, 8.5;
    2.5, 4.5, 6.5;
    3.5, 3.5, 5.5;
    4.5, 2.5, 4.5;
    5.5, 3.5, 5.5;
    6.5, 4.5, 6.5;
    8.5, 0.5, 8.5
];

% Compute state transition matrix from walls

% [State x Action] -> State
StateTransitionTable = zeros([NStates, NActions]);

for A = 1:NActions
    for S = 1:NStates
        P = posFromState(S);
        
        X = P(1);
        Y = P(2);
        NP = Actions(A,:) + P;
        MoveOK = 1;
        
        for W = 1:size(Walls_H, 1)
            WS = [Walls_H(W, 2) Walls_H(W, 1)];
            WE = [Walls_H(W, 3) Walls_H(W, 1)];
            MoveOK = MoveOK & ~testSegmentSegment(P, NP, WS, WE);
        end
        
        for W = 1:size(Walls_V, 1)
            WS = [Walls_V(W, 1) Walls_V(W, 2)];
            WE = [Walls_V(W, 1) Walls_V(W, 3)];
            MoveOK = MoveOK & ~testSegmentSegment(P, NP, WS, WE);
        end
        
        if (MoveOK)
            StateTransitionTable(S, A) = stateFromPos(NP);
        else
            StateTransitionTable(S, A) = S;
        end
    end
end

StateTransitionTable(GoalState, :) = repmat(GoalState, [NActions 1]);

%% Visualisation

% Policy representation: [State] -> Action
% from the goal state
StartPolicy = [
    1 4 4 4 4 4 4 3 ...
    1 4 4 1 1 1 4 3 ...
    1 4 4 2 4 3 4 3 ...
    1 1 4 2 4 2 4 3 ...
    1 2 4 2 3 2 4 3 ...
    1 2 1 1 1 2 1 4 ...
    1 2 3 3 1 1 2 4 ...
    1 2 3 3 1 1 2 4
]';

% Arrows for rendering state transitions
Arrow(1, :, :) = [
    0.25 0;
    0.75 0;
    0.625 -0.125;
    0.75 0;
    0.625 +0.125;
    0.75 0;
];
% Rotate for other directions
for A = 2:4
    for L = 1:size(Arrow, 2)
        Arrow(A,L,:) = Rot90^(A-1) * squeeze(Arrow(1,L,:));
    end
end

% Arrows for rendering policies
% 0 G X
ActionGlyphs(1, 1, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 1, :, :) = [-1 +1; +1 -1]';
% 1 E >
ActionGlyphs(1, 2, :, :) = [-1 +1; -1 +1]';
ActionGlyphs(2, 2, :, :) = [+1  0; -1  0]';
% 2 S V
ActionGlyphs(1, 3, :, :) = [-1  0; +1  0]';
ActionGlyphs(2, 3, :, :) = [+1 -1; +1 -1]';
% 3 W < 
ActionGlyphs(1, 4, :, :) = [+1 -1; +1 -1]';
ActionGlyphs(2, 4, :, :) = [+1  0; -1  0]';
% 4 N ^
ActionGlyphs(1, 5, :, :) = [-1  0; +1  0]';
ActionGlyphs(2, 5, :, :) = [-1 +1; -1 +1]';
% Rescale
ActionGlyphs = 0.25 * ActionGlyphs;

function drawWalls()
    for i = 1:size(Walls_H, 1)
        Y      = Walls_H(i,1);
        StartX = Walls_H(i,2);
        EndX   = Walls_H(i,3);

        line([StartX EndX], [Y Y], 'Color', 'red');
    end
    for i = 1:size(Walls_V, 1)
        X      = Walls_V(i,1);
        StartY = Walls_V(i,2);
        EndY   = Walls_V(i,3);

        line([X X], [StartY EndY], 'Color', 'red');
    end
end

function drawGlyph(Glyph, P)
    XS = squeeze([Glyph(1:2:end,1), Glyph(2:2:end,1)])';
    YS = squeeze([Glyph(1:2:end,2), Glyph(2:2:end,2)])';
    line(P(1) + XS, P(2) + YS, 'Color', 'green');
end

function drawStateTransitions()
    [NStates NActions] = size(StateTransitionTable);
    for A = 1:NActions
        for S = 1:NStates
            P = posFromState(S);
            if (StateTransitionTable(S, A) ~= S)
                drawGlyph(squeeze(Arrow(A,:,:,:)), P);
            end
        end
    end
end

function drawActionImpl(Glyphs, X, Y, A)
    XS = squeeze(Glyphs(1, A+1,:,:));
    YS = squeeze(Glyphs(2, A+1,:,:));
    line(X + XS, Y + YS, 'Color', 'blue');
end

function drawPolicy(Policy)
    [NStates] = size(Policy);
    
    for S = 1:NStates
        P = posFromState(S);
        X = P(1);
        Y = P(2);
        drawActionImpl(ActionGlyphs, X, Y, Policy(S));
    end
end

function vizPolicy(Fig, V, Policy)
     figure(Fig);
        imagesc(reshape(V, MapSize));
        colormap('gray');
        drawWalls();
        drawPolicy(Policy);
    axis([0.5, 8.5, 0.5, 8.5], 'xy', 'square');
end

figure(1);
    drawWalls();
    drawStateTransitions();
    drawPolicy(StartPolicy);
axis([0.5, 8.5, 0.5, 8.5], 'xy', 'square');

writeFigurePDF('StartingPolicy.pdf');

reward = @(S, A, S2) -1 * (S ~= GoalState);