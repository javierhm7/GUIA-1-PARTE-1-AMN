clc; clear;

disp('---------- METODO DE BISECCION ----------')

% ====== DEFINIR CONSTANTES (para que NO salga "Undefined variable") ======
s0 = 300;
m  = 0.25;
k  = 0.1;
g  = 32.17;

% Variable simbolica
syms x
% ====== FUNCION DEFINIDA EN EL PROGRAMA ======
s = s0 - (m*g/k)*x + (m^2*g/k^2)*(1 - exp(-k*x/m));

% ====== ENTRADAS ======
f = input('Introduzca la funcion: ');
a = input('Introduzca el valor de a: ');
b = input('Introduzca el valor de b: ');
tol = input('Ingrese el margen de error: 10^- ');
tol = 10^(-tol);

% ====== EVALUACIONES INICIALES ======
fa = subs(f, x, a);
fb = subs(f, x, b);

% ====== VERIFICACION ======
if fa*fb >= 0
    disp('No hay cambio de signo en el intervalo [a,b]. Cambie a y b.');
    return;
end

% ====== PRIMERA ITERACION ======
c  = (a + b)/2;
fc = subs(f, x, c);

cont  = 1;
error = abs(fc);   % criterio inicial 

fprintf('\n n ||        a         ||        b         ||        c         ||      error\n');
fprintf('%d || %.15f || %.15f || %.15f || %.6e\n', cont, double(a), double(b), double(c), double(error));

% ====== ITERACIONES ======
while error > tol
    cont = cont + 1;

    % Seleccion de subintervalo
    if fa*fc < 0
        b  = c;
        fb = fc;
    else
        a  = c;
        fa = fc;
    end

    % Nuevo punto medio
    c_new = (a + b)/2;
    error = abs(c_new - c);   % error entre aproximaciones (muy usado)
    c = c_new;

    fc = subs(f, x, c);

    fprintf('%d || %.15f || %.15f || %.15f || %.6e\n', cont, double(a), double(b), double(c), double(error));
end

fprintf('\nEl valor aproximado de X es: %.15f\n', double(c));
