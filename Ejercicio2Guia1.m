clc; clear; format long;

Q = 72.910915731844;

% Raíz cúbica real (más estable que x^(1/3))
cbrt = @(z) nthroot(z,3);

% Función del problema
f = @(x) (x + cbrt(x)) .* ((13.6 - x) + cbrt(13.6 - x)) - Q;

% Intervalo correcto (encierra una raíz)
a = 5.3;
b = 5.4;

tol = 1e-5;
maxit = 200;

fa = f(a);
fb = f(b);

if fa*fb > 0
    error('No hay cambio de signo en el intervalo');
end

% Tabla: n | a | b | c | f(c) | (b-a)/2
tabla = [];

n = 0;
while (b - a)/2 > tol && n < maxit
    n = n + 1;

    c = (a + b)/2;
    fc = f(c);

    % Guardar TODOS los valores sin aproximar
    tabla(n,:) = [n, a, b, c, fc, (b-a)/2];

    if fa*fc < 0
        b = c;
        fb = fc;
    else
        a = c;
        fa = fc;
    end
end

x = c;
y = 13.6 - x;

% Mostrar tabla completa
disp('Tabla de iteraciones (SIN APROXIMAR):');
disp(' n        a               b               c               f(c)            (b-a)/2');
disp(tabla);

fprintf('\nResultado final:\n');
fprintf('x = %.15f\n', x);
fprintf('y = %.15f\n', y);

