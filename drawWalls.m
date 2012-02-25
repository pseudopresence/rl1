function drawWalls(V, H)
    for i = 1:size(V, 1)
        Y      = V(i,1);
        StartX = V(i,2);
        EndX   = V(i,3);

        line([StartX EndX], [Y Y], 'Color', 'red');
    end
    for i = 1:size(H, 1)
        X      = H(i,1);
        StartY = H(i,2);
        EndY   = H(i,3);

        line([X X], [StartY EndY], 'Color', 'red');
    end
end
