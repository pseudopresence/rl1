function drawArrow(Arrow, P, A)
    % TODO ugh
    XS = squeeze(Arrow(A,:,:,1))';
    YS = squeeze(Arrow(A,:,:,2))';
    line(P(1) + XS, P(2) + YS, 'Color', 'green');
end