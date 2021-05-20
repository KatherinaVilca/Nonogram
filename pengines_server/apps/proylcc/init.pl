
:- module(init, [ init/3 ]).

init(
[[3], [1,2], [4], [5], [5]],	% PistasFilas

[[2], [5], [1,3], [5], [4]], 	% PistasColumnas

[["X", _ , _ , _ , _ ], 		
 ["X", _ ,"X", _ , _ ],
 ["X", _ , _ , _ , _ ],		% Grilla
 ["#","#","#", _ , _ ],
 [ _ , _ ,"#","#","#"]
]
).

% colocar "#" en fila 2 columna 2  4rellenas en fila y  [1,3] en columna
% si la posicion contiene una "X" entonces -> ¿?
% si la posicion NO contiene una "X" entonces
    % Obtener las pistas de la fila y las pistas de la columna
    % Obtener estado actual de la grilla (obtener fila y columna donde se insertó)
    %Verificar posicion valida -> si las pistas estan satisfechas entonces, poner una cruz (posicion invalida)
    %                             si no -> si la posicion es invalida (originalmente no iría un "#" ahi) descontar valida
    %                             si no -> marcar esa posicion con "#"
    %                                      si marcamos y cumplimos todas las pistas -> marcar las blancas que queden (si quedan) con "X" y actualizar label de pistas de color verde
    %                             retornar grilla actualizada


    % como verificar (dada la posicion) -> Primero: para cada pista (Fila, columna)  -> verificar que tengo espacio suficiente para satisfacer todas (esto es, si tengo como pista en la fila F 4 tengo que poder insertar 3 consecutivos).                         
    %                                         si columna no verifica -> marco columna como inválida (solo encabezado de pista, no casilla especifica).
    %                                           si no
    %                                             si fila no verifica -> marco fila como invalida (pintando el encabezado de la fila, no casilla especifica).
    %                                     si verifico, entonces pinto la celda (podría ser una posicion valida).  

    %contador es cantidad de pistas en fila o columna
    % Leo la lista, si la posicion es "_" ó "#" contador--. Si contador == 0, cumple  .

    %verificar:
    % Tengo lista de pistas y lista fila de grilla.
    % Tomar la primera pista.
    % Si el primer lugar de lista fila de grilla es # o _ 
    %       llamar a verificar consecutivos con el primer elemento de la lista de pistas, y con la lista de fila de grilla.
    %               verificar consecutivos ( NroPista, [E|FilaS], Fila restante)
                        Tomo el primer elemento de fila y si es igual a # o _ ,
                        Naux NroPista - 1,
                        volver a llamar a verificar consecutivos con Naux, FilaS, Fila restante).
                    
                    Si NroPista es 0, Elemento de la FilaS es "X" , Retornar fila restante.

            % tomar siguiente de la lista de pistas y fila restante. Repetir lo anterior.

    % Si no, si es X, llamar a verificar con la lista fila de grilla sin ese elemento.

    % lista de pistas es vacia y fila grilla es vacia entonces retornar 1 (Se cumple).
    % Sino retornar 0.