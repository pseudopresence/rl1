function [Coll] = testSegmentSegment(S1, E1, S2, E2)
  % Algorithm from Computational Geometry in C (Second Edition)
  D1 = E1 - S1;
  D2 = E2 - S2;

  U = S2 - S1;

  % Might be negative!
  Scale = D1(2) * D2(1) - D1(1) * D2(2);

  R = (U(1) * D2(2) - U(2) * D2(1)) / Scale;
  S = (U(1) * D1(2) - U(2) * D1(1)) / Scale;

  Coll = (0 < R) & (R < 1) & (0 < S) & (S < 1);
end