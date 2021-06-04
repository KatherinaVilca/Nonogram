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

	verificarFila(RowN,PistasFilas,NewGrilla,FilaSat),							% Verifica si para la fila se cumple lo indicado en su respectiva lista fila de pistas, en caso de cumplirse FilaSat es 1, caso contrario 0.
     verificarColumna(ColN,PistasColumnas,NewGrilla, ColSat).					% Verifica si para la columna se cumple lo indicado en su respectiva lista columna de pistas, en caso de cumplirse ColSat es 1, caso contrario 0.


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% obtener_columna(+Grilla,+Columna,+ListaDeElementosDeLaColumna)

	obtener_columna([Fila], Col, FilaC):-	   %Caso base, unica fila.
    	nth0(Col,Fila,AuxC),				   %FilaC es una lista con el elem que busco.
		FilaC= [AuxC].

	obtener_columna([Fila|Grilla] , Col, FilaC):-
    	obtener_columna(Grilla,Col,FilaRecursiva),
    	nth0(Col,Fila,Aux),
    	append([Aux],FilaRecursiva,FilaC).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	verificarColumna(IndiceColumna,PistasFilas,GrillaRes, 1) :-
	nth0(IndiceColumna,PistasFilas,FiladePistas),
	obtener_columna(GrillaRes,IndiceColumna,ColumnaDeGrilla),
	verificarPistasEnLista(FiladePistas,ColumnaDeGrilla).
	verificarColumna(_,_,_,0).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%
	% verificarPistasEnLista(+Pistas, +)
	%

	verificarPistasEnLista([],ListaFila):-not(member("#",ListaFila)).

	verificarPistasEnLista([X|PistasS],[Y|ListaFilaS]):-Y == "#",
		verificarPconsecutivos(X,[Y|ListaFilaS],Restante),
		verificarPistasEnLista(PistasS,Restante).

	verificarPistasEnLista(Pistas,[Y|ListaFilaS]):- Y \== "#", 				   % Dada la lista de pistas, y el primer elemento de ListaFilaS (lista de fila)
		verificarPistasEnLista(Pistas,ListaFilaS).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%
	% verificarPconsecutivos( +NumeroPista, +FilaARecorrer, -FilaRestante)
	%

	verificarPconsecutivos(0,[],[]).														   

	verificarPconsecutivos(0,[X|Filarestante],Filarestante):- X \== "#".

	verificarPconsecutivos(N,[X|Filarestante],Filarestante2):- X == "#", N > 0, Naux is N-1,   %
		verificarPconsecutivos(Naux,Filarestante,Filarestante2).


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% verifica que la fila/columna tenga sus pistas satisfechas.
	% 1==TRUE, 0==FALSE
	%
	% verificarFila(+Posicion,+ListaPistas,+GrillaRes,-N)
	%

	verificarFila(IndiceFila,PistasFilas,GrillaRes, 1) :-
	nth0(IndiceFila,PistasFilas,FiladePistas),				% Obtiene las pistas de la fila, de la lista de pistas de las filas
	nth0(IndiceFila,GrillaRes,Filadegrilla),				% Obtiene la fila correspondiente a la posicion fila, de la grilla
    verificarPistasEnLista(FiladePistas,Filadegrilla).		% Dada la lista de pistas de fila ( fila de pistas) y la fila de la grilla, verifica

	verificarFila(_,_,_,0).									% Si termino de recorrer ambas listas y no se verifica las pistas en lista, retorna 0.

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
