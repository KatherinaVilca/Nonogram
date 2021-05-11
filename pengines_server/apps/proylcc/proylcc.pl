:- module(proylcc,
	[  
		put/8
	]).

:-use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY es el resultado de reemplazar la ocurrencia de X en la posición XIndex de Xs por Y.

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat).
%

put(Contenido, [RowN, ColN], _PistasFilas, _PistasColumnas, Grilla, NewGrilla, 0, 0):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	 
	%Si la pos es X o vacio verifica fila y columna si y solo el contenido es #.
	%verificar_fila()

	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)).


	%Verificar si se trata de una jugada valida si no se excedio el numero de pistas
	%Si intento agregar un "#" en una fila/columna que ya está completa 
	% (pueden quedar espacios blancos pero las pistas ya estan satisfechas) 
	% debería quitar una vida y poner una cruz en el espacio blanco donde se intentó insertar el #
	%Deberiamos recorrer la lista de pistas por Rown y por colN 
	%Agregar: obtener_cant_pista_(+Posicion, + _Pistas,-Cant).
	% Agregar: obtener_fila_grilla(+Grilla,+Posicion,-ListaFila).
	%Agregar boton verificar.
	%Agregar boton modo de juego( x o #).
	%Agregar predicado a donde de forma recursiva va contando la cantidad de celdas pintadas.
	% cant_celdas_pintadas(_ListaFila,+CantPistas,-CantPintadas)


	verificar_fila(Contenido,Rown,-ListaFila,-Cant,-Flag):-  %Flag= true o false.
	Contenido== "#" %Si es una celda a pintar.
	%Llamar a predicado cant_celdas_pintadas, de ahi sacar la cantidad que estan pintadas
	%Si cantidad de celdas pintadas es mayor a la cantidad de pistas de la fila return false. Pintar como invalida. Restar una vida.

	verificar_consecutivos(0,[Elem|FilaRestante],FilaRestante):- Elem\== "#".
	verficar_consecutivos(N,[Elem,FilaRestante],Aux):-
    Elem== "#",
    N>0,
    Naux is N-1,
    verificar_consecutivos(Naux,FilaRestante,Aux).

	% obtener_lista(+Posicion,+ListaConListas, -Sublista)

		obtener_lista(Pos,ListaPistas,Lista):-
    		obtener_lista_recursiva(0,Pos,ListaPistas,Lista).

	
			obtener_lista_recursiva(X,Pos,[Elem|LPs],Lista):-
    			( X\=Pos)-> Xs is X+1, obtener_lista_recursiva(Xs,Pos,LPs,Lista)
   				; lista = Elem.

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% obtener_columna(+TableroGrilla,+Columna,+ListaDeElementosDeLaColumna)
	
		obtener_columna(Grilla, Col, ListaElementosColumna):-
    		obtener_columna_recursiva(Grilla,Col, ListaAux),
    		invertir(ListaAux,ListaElementosColumna).

			obtener_columna_recursiva([Fila], Col,FilaC):- %Caso base, unica fila.
   				obtener_lista(Col,Fila,AuxC), 			   %FilaC es una lista con el elem que busco.
    			FilaC= [AuxC].

			obtener_columna_recursiva([Fila|Grilla], Col, FilaC):-
    			obtener_columna_recursiva(Grilla,Col,FilaRecursiva),
    			obtener_lista(Col,Fila,Aux),
    			insertar_final(Aux,FilaRecursiva,FilaC).
			
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% PREDICADOS AUXILIARES.
	
	invertir([],[]). % Caso base, lista vacia.
	
	invertir([X|Xs],Res):- % X elemento de la lista, Xs resto de la lista
		invertir(Xs,Aux), %aux lista , Caso recursivo
		insertar_final(X,Aux,Res). % X el ultimo elem leido

	insertar_final(A,[], [A]). %caso base, si la primeralista esta vacia, inserto el elem en la segunda.
		insertar_final(A,[Elem|Listarestante],[Elem|Listaresultado]):-
    	insertar_final(A,Listarestante,Listaresultado).
