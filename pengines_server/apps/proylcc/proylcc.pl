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

put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat):-
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
	replace(_Cell, ColN, Contenido, Row, NewRow)),

	verificarFila(RowN,PistasFilas,NewGrilla,FilaSat),
     verificarColumna(ColN,PistasColumnas,NewGrilla, ColSat).


	% ---------- Tener en cuenta -----------

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% En el caso que se cumplan las pistas de fila y columna --> FilaSat 1, ColSat1.
	% En el caso de cumplir pistas columna , PERO me paso de la cantidad de pistas de fila --> FilaSat 0, ColSat 1
	% En el caso de cumplir pistas Fila , PERO me paso de la cantidad de pistas columna --> FilaSat 1 , ColSat 0
	% En el caso de cumplir pistas columna, PERO me FALTA para completar pistas fila --> FilaSat 0, ColSat 1.
	% En el caso de cumplir pistas fila, PERO ME FALTA para completar pistas columna --> FilaSat 1, ColSat 0.
	% En el caso de que ME FALTE para completar pistas fila, y ME FALTE para completar pistas columna --> FilaSat 0 , ColSat 0.



   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% PREDICADOS AUXILIARES.

	invertir([],[]). % Caso base, lista vacia.

	invertir([X|Xs],Res):- % X elemento de la lista, Xs resto de la lista
		invertir(Xs,Aux), %aux lista , Caso recursivo
		insertar_final(X,Aux,Res). % X el ultimo elem leido

	insertar_final(A,[], [A]). %caso base, si la primeralista esta vacia, inserto el elem en la segunda.

	insertar_final(A,[Elem|Listarestante],[Elem|Listaresultado]):-
	insertar_final(A,Listarestante,Listaresultado).



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% obtener_columna(+TableroGrilla,+Columna,+ListaDeElementosDeLaColumna)

		obtener_columna(Grilla, Col, ListaElementosColumna):-
		obtener_columna_recursiva(Grilla,Col, ListaAux),
		invertir(ListaAux,ListaElementosColumna).

			obtener_columna_recursiva([Fila], Col,FilaC):- %Caso base, unica fila.
				nth0(Col,Fila,AuxC),				   %FilaC es una lista con el elem que busco.
			FilaC= [AuxC].

			obtener_columna_recursiva([Fila|Grilla], Col, FilaC):-
			obtener_columna_recursiva(Grilla,Col,FilaRecursiva),
			nth0(Col,Fila,Aux), %ccambie obtener fila por nth
			insertar_final(Aux,FilaRecursiva,FilaC).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	verificarColumna(IndiceColumna,PistasFilas,GrillaRes, 1) :-
	nth0(IndiceColumna,PistasFilas,FiladePistas),
	obtener_columna(GrillaRes,IndiceColumna,ColumnaDeGrilla),
	verificarPistasEnLista(FiladePistas,ColumnaDeGrilla).
	verificarColumna(_,_,_,0).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	verificarPistasEnLista([],ListaFila):-not(member("#",ListaFila)).

	verificarPistasEnLista([X|PistasS],[Y|ListaFilaS]):-Y == "#",
		verificarPconsecutivos(X,[Y|ListaFilaS],Restante),
		verificarPistasEnLista(PistasS,Restante).

	verificarPistasEnLista(Pistas,[Y|ListaFilaS]):- Y \== "#", % Aca empieza
		verificarPistasEnLista(Pistas,ListaFilaS).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	verificarPconsecutivos(0,[],[]).

	verificarPconsecutivos(0,[X|Filarestante],Filarestante):- X \== "#".

	verificarPconsecutivos(N,[X|Filarestante],Filarestante2):- X == "#", N > 0, Naux is N-1,
		verificarPconsecutivos(Naux,Filarestante,Filarestante2).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%verifica que la fila/columna tenga sus pistas satisfechas.
	% 1==TRUE, 0==FALSE
	%verificarFila(+Posicion,+ListaPistas,+GrillaRes,-N)
	%

	verificarFila(IndiceFila,PistasFilas,GrillaRes, 1) :-
	nth0(IndiceFila,PistasFilas,FiladePistas),
	nth0(IndiceFila,GrillaRes,Filadegrilla),
    verificarPistasEnLista(FiladePistas,Filadegrilla).

	verificarFila(_,_,_,0).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%todasPistasSatisfechas(+ListaPistasAux,-Num) -> ver si conviene que ListaPistaAux sea una lista auxiliar la
	%													 cual cada vez que se satisface una fila o columna,
	%al final del put iría este metodo, que verifica filas y columnas
	%todasPistasSatisfechas([], Num). % retornamos true
	%todasPistasSatisfechas([Xs|X], Num):-
	%				Xs==true,
	%				todasPistasSatisfechas(X,Num).
	% Si estan satisfechas, ganó el juego.

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

