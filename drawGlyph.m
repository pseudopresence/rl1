function drawGlyph(Glyph, P)
    % TODO ugh
    XS = squeeze([Glyph(1:2:end,1), Glyph(2:2:end,1)])';
    YS = squeeze([Glyph(1:2:end,2), Glyph(2:2:end,2)])';
    line(P(1) + XS, P(2) + YS, 'Color', 'green');
end