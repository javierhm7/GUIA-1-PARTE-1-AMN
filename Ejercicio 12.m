% Fórmula del volumen: V = pi*h²*(3R - h)/3

try
    pkg load symbolic;
catch
end

clear;  % Limpiar variables usadas antes
format long;  % Mostrar números con alta precisión (15 decimales)

% SECCIÓN 1: ENTRADA DE DATOS
% (Evita un error) ---  Si no empieza automáticamente, presionar un número cualquiera y Enter
drawnow;
if exist('fflush', 'builtin'), fflush(stdout); end

% Solicitar el volumen deseado
V = input('Ingrese el volumen deseado (V) en metros cúbicos: ');

% Solicitar el radio del tanque
R = input('Ingrese el radio del tanque (R) en metros: ');

% Solicitar la tolerancia
pow = input('Ingrese la potencia de la tolerancia (ej: si es 10^-12 escriba 12): ');
tolerancia = 10^-pow;

% Solicitar el valor inicial de h (valor para probar)
fprintf('\nValor recomendado entre 0 y 2R (0 < h < %.2f)\n', 2*R);
h0 = input('Ingrese el valor inicial de h en metros: ');

% SECCIÓN 2: DEFINICIÓN DE LA FUNCIÓN Y LA DERIVADA
fprintf('\n---------------------------------------------------------\n');
fprintf('  Calculando...\n');

% Definir la variable simbólica
syms h_sym;

% Definir la función f(h) = pi*h²*(3R - h)/3 - V
f_sym = pi * h_sym^2 * (3*R - h_sym) / 3 - V;

% Calcular la derivada f'(h) 
f_prima_sym = diff(f_sym, h_sym);

% Convertir las expresiones simbólicas a funciones numéricas
f_func = matlabFunction(f_sym);
f_prima_func = matlabFunction(f_prima_sym);

fprintf('Función a resolver configurada correctamente.\n');

% SECCIÓN 3: IMPLEMENTACIÓN DEL MÉTODO DE NEWTON-RAPHSON
fprintf('=========================================================\n');
fprintf('  ITERACIONES DEL MÉTODO DE NEWTON-RAPHSON\n');
fprintf('%-12s %-25s %-25s %-25s\n', 'Iteración', 'h', 'f(h)', 'f''(h)');
fprintf('%-12s %-25s %-25s %-25s\n', '---------', '-----------------', ...
        '-----------------', '-----------------');

% Inicializar variables
h_actual = h0;
iteracion = 0;
max_iteraciones = 1000; %Pone límite al número de iteraciones

% Bucle iterativo de Newton-Raphson
while iteracion < max_iteraciones
    % Evaluar f(h) y f'(h)
    f_valor = f_func(h_actual);
    f_prima_valor = f_prima_func(h_actual);
    
    % Mostrar los valores de la iteración actual
    fprintf('%-12d %-25.15f %-25.15e %-25.15f\n', ...
            iteracion, h_actual, f_valor, f_prima_valor);
    
    % Verificar convergencia
    if abs(f_valor) < tolerancia
        fprintf('\n¡Convergencia alcanzada!\n');
        break;
    end
    
    % Verificar que la derivada no sea cero
    if abs(f_prima_valor) < 1e-15
        fprintf('\nError: La derivada es muy cercana a cero.\n');
        break;
    end
    
    % Aplicar fórmula de Newton-Raphson
    h_nuevo = h_actual - f_valor / f_prima_valor;
    
    % Actualizar variables
    h_actual = h_nuevo;
    iteracion = iteracion + 1;
end

% SECCIÓN 4: RESULTADOS FINALES
fprintf('  RESULTADOS \n');
fprintf('Número total de iteraciones: %d\n', iteracion);
fprintf('Profundidad del agua (h) = %.15f metros\n', h_actual);
fprintf('Volumen verificado (V)   = %.15f m³\n', ...
        pi * h_actual^2 * (3*R - h_actual) / 3);
fprintf('Error final |f(h)|       = %.15e\n', abs(f_func(h_actual)));
fprintf('=========================================================\n');

% SECCIÓN (EXTRA): VERIFICACIÓN DE LA SOLUCIÓN
fprintf('  VERIFICACIÓN DE LA SOLUCIÓN\n');

% Calcular el volumen con el h encontrado
V_calculado = pi * h_actual^2 * (3*R - h_actual) / 3;

% Calcular el error relativo
error_absoluto = abs(V_calculado - V);
error_relativo = (error_absoluto / V) * 100;

% Verificar que h esté en el rango físicamente válido
h_valido = (h_actual > 0) && (h_actual <= 2*R);

% Mostrar resultados de verificación
fprintf('Volumen deseado (V):        %.15f m³\n', V);
fprintf('Volumen calculado con h:    %.15f m³\n', V_calculado);
fprintf('Error absoluto:             %.15e m³\n', error_absoluto);
fprintf('Error relativo:             %.15e %%\n', error_relativo);
fprintf('---------------------------------------------------------\n');
fprintf('Rango válido para h:        0 < h < %.15f m\n', 2*R);
fprintf('Valor de h encontrado:      %.15f m\n', h_actual);

% Mostrar si h está en rango válido
if h_valido
    fprintf('¿h está en rango válido?    SÍ \n');
else
    fprintf('¿h está en rango válido?    NO \n');
end

fprintf('---------------------------------------------------------\n');

% Determinar si la solución es correcta
solucion_aceptable = h_valido && (error_absoluto < tolerancia);

if solucion_aceptable
    fprintf('\n SOLUCIÓN VERIFICADA CORRECTAMENTE\n');
    fprintf('  La profundidad h encontrada es válida y cumple con\n');
    fprintf('  la tolerancia especificada (%.0e).\n', tolerancia);
else
    fprintf('\n? PROBLEMAS EN LA VERIFICACIÓN\n');
    if ~h_valido
        fprintf('  - El valor de h está fuera del rango válido.\n');
    end
    if error_absoluto >= tolerancia
        fprintf('  - El error excede la tolerancia especificada.\n');
    end
end

% Evita que se cierre
fprintf('\n Presione cualquier tecla para salir...\n');
pause;
