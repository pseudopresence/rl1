function drawAction(Glyphs, X, Y, A)
    line(X + 0.25 * squeeze(Glyphs(1, A+1,:,:)), Y + 0.25 * squeeze(Glyphs(2, A+1,:,:)), 'Color', 'blue');
end