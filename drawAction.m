function drawAction(Glyphs, X, Y, A)
    % TODO change X,Y to P
    line(X + squeeze(Glyphs(1, A+1,:,:)), Y + squeeze(Glyphs(2, A+1,:,:)), 'Color', 'blue');
end