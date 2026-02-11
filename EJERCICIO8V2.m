clc; clear;

disp('intervalo donde cumple ambas condiciones: [155, 160]')
disp('--------------- METODO DE PUNTO FIJO ----------------')

% ====== DATOS DEL PROBLEMA ======
Z = 75;          % Impedancia (Ohm)
R = 225;         % Resistencia (Ohm)
C = 0.6e-6;      % Capacitancia (F)
L = 0.5;         % Inductancia (H)

% ====== DEFINICION DE LA FUNCION g(x) ======
g = @(x) x .* Z .* sqrt( (1/(R^2)) + (x*C - 1./(x*L)).^2 );

% ====== ENTRADAS ======
disp('Ingrese la funcion: g')
x0  = input('Ingrese el punto inicial: ');
tol = input('Ingrese el margen de error: 10^- ');
tol = 10^(-tol);

% ====== CABECERA DE LA TABLA ======
fprintf('\n n | X0 | X1 | ERROR\n');

% ====== PRIMERA ITERACION ======
x1 = g(x0);
error = abs(x1 - x0);
n = 1;

fprintf('%d | %.15f | %.15f | %.6e\n', n, x0, x1, error);

% ====== METODO DE PUNTO FIJO ======
while error > tol
    x0 = x1;
    x1 = g(x0);
    error = abs(x1 - x0);
    n = n + 1;

    fprintf('%d | %.15f | %.15f | %.6e\n', n, x0, x1, error);
end

fprintf('\nEl valor aproximado de X es: %.15f\n', x1);
