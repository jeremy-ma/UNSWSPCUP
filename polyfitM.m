function P = polyfitM(x, matrixY, n)
% [sx1, sx2] = size(x);
[sx1, sx2] = size(matrixY);
P = zeros(sx1, n+1);

%   x = matrixX(Index, :);
  
  x = x(:);
%   q = ones(sx2, 1);
%   V(:, n+1) = q;
%   for j = n:-1:1
%     q = q .* x;
%     V(:, j) = q;
%   end
  V = vander(x);
  [Q, R] = qr(V, 0);
for Index = 1:sx1
    y = matrixY(Index, :)';
%     y = y(:);
  P(Index, :) = (R \ (Q' * y))';
end

end