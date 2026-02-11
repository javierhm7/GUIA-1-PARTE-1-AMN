format long;

Ti = 184.40;
Q  = 2890;

Cp = @(T) 32.24 + 0.001924*T + 1.055e-5*T.^2 - 3.596e-9*T.^3;

F  = @(T) 32.24*T + 0.001924*T.^2/2 + 1.055e-5*T.^3/3 - 3.596e-9*T.^4/4;

f  = @(Tf) (F(Tf) - F(Ti)) - Q;

tol = 1e-10;
maxit = 500;

% buena estimación inicial (balance aproximado)
x0 = Ti + Q/Cp(Ti);

lambda = 0.05;            % aceleración estable
g = @(T) T - lambda*f(T); % punto fijo

fprintf('n\t x0\t\t\t x1\t\t\t error\n');

for n = 1:maxit
  x1 = g(x0);
  err = abs(x1 - x0);

  fprintf('%d\t %.15f\t %.15f\t %.5e\n', n, x0, x1, err);

  if err < tol
    break;
  end
  x0 = x1;
end

fprintf('\nTf = %.15f °C\n', x1);

