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

	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Contenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)).


	% ---------- COMPLETAR -----------

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		
		
    	obtener_lista([PosX|_Pos],PistasFilas,PistasFila), %obtengo lista de pistas de la fila PosX
		nth0(1,Pos,PosY),  									%Obtengo PosY
    
    	obtener_fila(Y,PistasColumnas,PistasColumna),			%Obtengo pistas de la columna.
    	obtener_fila(PosX,NewGrilla,ListaFila), 						%Obtengo la fila de la grilla.
		obtener_columna(PosY,Grilla,ListaColumna),					%Obtengo la columna de la grilla
		NFila is 1,
    	verificar_lista(PistasFila,ListaFila,NLista),                %%VER . DEBERIA MANDAR UNA VARIABLE.    FILA
		NColumna is 1,
		verificar_lista(PistasColumna,ListaColumna,NColumna),		%COLUMNA

		FilaSat = NFila,
		ColSat = NColumna.





	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	verificar_lista(PistasFila,ListaFila,1):-
   		verificarPistasEnLista(PistasFila,ListaFila).

	verificar_lista(_,_,_,0).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	verificarPistasEnLista([],ListaFila):-not(member("#",ListaFila)).

	verificarPistasEnLista([X|PistasS],[Y|ListaFilaS]):-Y == "#", 
    	verificarPconsecutivos(X,[Y|ListaFilaS],Restante),
    	verificarPistasEnLista(PistasS,Restante).

	verificarPistasEnLista(Pistas,[Y|ListaFilaS]):- Y \== "#", % Aca empieza
  		verificarPistasEnLista(Pistas,ListaFilaS).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	verificarPconsecutivos(0,[],[]).
	
	verificarPconsecutivos(0,[X|Filarestante],Filarestante):- X \== "#".
	
	verificarPconsecutivos(N,[X|Filarestante],Filarestante2):- X == "#", N > 0, Naux is N-1,
    	verificarPconsecutivos(Naux,Filarestante,Filarestante2).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% obtener_lista(+Posicion,+ListaConListas, -Sublista)

		obtener_fila(Pos,ListaPistas,Lista):-
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
   				obtener_fila(Col,Fila,AuxC), 			   %FilaC es una lista con el elem que busco.
    			FilaC= [AuxC].

			obtener_columna_recursiva([Fila|Grilla], Col, FilaC):-
    			obtener_columna_recursiva(Grilla,Col,FilaRecursiva),
    			obtener_fila(Col,Fila,Aux),
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

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	

	% ------------------- VERSION ORIGINIAL -----------------------

	% verificarFila([IndiceFila|_Pos],PistasFilas,GrillaRes, 1) :- 
    % nth0(IndiceFila,PistasFilas,FiladePistas),
    % nth0(IndiceFila,GrillaRes,Filadegrilla),
    % verificarPistasEnLista(FiladePistas,Filadegrilla).
	% verificarFila(_,_,_,0).	

	% verificarPistasEnLista([],FiladeGrilla):-not(member("#",FiladeGrilla)).

	% verificarPistasEnLista([X|PistasRestantes],[Y|SubfiladeGrilla]):-Y == "#", 
    % verificarPconsecutivos(X,[Y|SubfiladeGrilla],Restante),
    % verificarPistasEnLista(PistasRestantes,Restante).

	% verificarPistasEnLista(Pistas,[Y|SubfiladeGrilla]):- Y \== "#", % Aca empieza
  	% verificarPistasEnLista(Pistas,SubfiladeGrilla).

	% verificarPconsecutivos(0,[],[]).
	% verificarPconsecutivos(0,[X|Filarestante],Filarestante):- X \== "#".
	% verificarPconsecutivos(N,[X|Filarestante],Filarestante2):- X == "#", N > 0, Naux is N-1,
    % verificarPconsecutivos(Naux,Filarestante,Filarestante2).
