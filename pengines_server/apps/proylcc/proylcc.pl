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
	
	consecutivos(0,[],[]).														   

	consecutivos(0,[X|Filarestante],Filarestante):- X = "X".

	consecutivos(N,[X|Filarestante],Filarestante2):- X = "#", N > 0, Naux is N-1,   
		consecutivos(Naux,Filarestante,Filarestante2).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	controlar([],[Y|Ys]):- Y = "X", controlar([],Ys).
	controlar( [],[]).
	controlar([X|Xs], [Y|Ys]):- Y = "#", (   consecutivos(X,[Y|Ys],Res), controlar(Xs,Res)).
	controlar([X|Xs], [Y|Ys]):- Y = "X", controlar([X|Xs], Ys).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	interseccion( JugadasPosibles, Longitud, Salida):-
		AuxLongitud is Longitud -1,
		interseccionR( JugadasPosibles, AuxLongitud, [], Salida).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%caso base.
	interseccionR(_,-1,Aux,Aux).

	%% Caso: Agregar #
	interseccionR(JugadasPosibles,AuxLongitud, Aux, Salida):-
		obtener_columna(JugadasPosibles, AuxLongitud, ListaElementos),
		todosIguales("#", ListaElementos),
		append(["#"], Aux, ListaValida), %Si se verifico la listaelementos, agrego # a mi lista valida.
		AuxL is AuxLongitud - 1,
		interseccionR(JugadasPosibles,AuxL, ListaValida, Salida).

	%% Caso: Agregar X
	interseccionR(JugadasPosibles,AuxLongitud, Aux, Salida):-
	obtener_columna(JugadasPosibles, AuxLongitud, ListaElementos),
	todosIguales("X", ListaElementos),
	append(["X"], Aux, ListaValida), %Si se verifico la listaelementos, agrego
	AuxL is AuxLongitud - 1,
		interseccionR(JugadasPosibles,AuxL, ListaValida, Salida).

	%% Caso: Agregar espacio vacio 
	interseccionR(JugadasPosibles,AuxLongitud,Aux,Salida):-
		append([_], Aux,ListaValida), %Agrego vacio (   se que en esa posicion no va nada)
		AuxL is AuxLongitud - 1,
		interseccionR(JugadasPosibles,AuxL , ListaValida,Salida).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	todosIguales(_Elem,[]).

	todosIguales(Elem, [E|ListaE]):-
		E == Elem,
		todosIguales(Elem, ListaE).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	solucionFilas(Grilla ,LongAuxFilas,PistasFilas, Solucion):-
		solucionRec(Grilla,PistasFilas, LongAuxFilas, [], Solucion).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	solucionRec([Fila|Grilla] ,[Pista|ListaPistas], Longitud, Aux, Solucion):-
		findall(Fila, ( length(Fila, Longitud), controlar(Pista, Fila)),Resultado),
		interseccion(Resultado,Longitud, Res),
		append(Aux,[Res],ListaSolucionFila),
		solucionRec(Grilla, ListaPistas, Longitud,ListaSolucionFila,Solucion).


	solucionRec( [], [], _Longitud, Aux, Aux).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	solucionUnicaFila(Fila, PistaFila, Longitud, SolucionFila):-
		findall(Fila, ( length(Fila, Longitud), controlar(PistaFila, Fila)), Resultado),
		interseccion(Resultado, Longitud, SolucionFila).
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	columnas( Grilla , Long, ListaAux, ListaColumnas):-
		Pos is Long - 1,   
		obtener_columna(Grilla,Pos, AuxLista),
		append([AuxLista], ListaAux, ListaA),
		Pos \== -1 ->  columnas(Grilla, Pos, ListaA, ListaColumnas) ; ListaColumnas = ListaAux.
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	solucionColumna(Grilla, LongAuxColumnas,PistasColumna, Solucion):-
		length(PistasColumna, L),
		columnas(Grilla, L,[], ListaColumnas),
		solucionRec(ListaColumnas,PistasColumna, LongAuxColumnas,[], Solucion).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	sumaPistasFila([], 0).
	sumaPistasFila([Elemento | Lista], Suma) :-
		sumaPistasFila(Lista, SumaAux),
		Suma is SumaAux + Elemento.

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%
	% Si la cantidad de pistas + la Longitud de las pistas - 1 es igual a Longitud de la Lista
	% entonces la solucion será unica.
	%
	esUnicaSolucion(Suma_pistas, Longitud_pistas, Longitud_lista) :-
		(Suma_pistas + Longitud_pistas) - 1 =:= Longitud_lista.

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% es lista con unica solucion?
	%
	esListaConUnicaSol(Lista_pistas, Lista_grilla) :-
		sumaPistasFila(Lista_pistas, Suma_pistas),
		length(Lista_pistas, Longitud_pistas),
		length(Lista_grilla, Longitud_lista),
		esUnicaSolucion(Suma_pistas, Longitud_pistas, Longitud_lista).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% primerPasada
	% columnas( Grilla , Long, ListaAux, ListaColumnas):-

	primeraPasada(GrillaIn, PistasFila, PistasCol, LengthFila, LengthColum, GrillaAcomodada):-
		resolverFilaTrivial(GrillaIn, PistasFila, GrillaRes, LengthFila),
		columnas(GrillaRes,LengthFila, [], ListaColumnas),
		resolverColumnaTrivial(ListaColumnas, PistasCol, GrillaResultado, LengthColum, 0),
		columnas(GrillaResultado, LengthColum, [] , GrillaAcomodada).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Resolver Pistas Triviales de todas Filas
	%
	resolverFilaTrivial([], [], [], _).

	resolverFilaTrivial([Fila|RestoGrilla], [Pista|RestoPista], [FilaSalida|RestoSalida], L):-
		esListaConUnicaSol(Pista, Fila),
		solucionUnicaFila(Fila, Pista, L, FilaSalida),
		resolverFilaTrivial(RestoGrilla, RestoPista, RestoSalida, L).
		

	resolverFilaTrivial([Fila|Resto], [_Pista|RestoPista], [Fila|RestoSalida], L):-
		resolverFilaTrivial(Resto, RestoPista, RestoSalida, L).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% primerPasadaColumna
	%
	resolverColumnaTrivial([], [], [], _, _).

	resolverColumnaTrivial([PrimerColumnaGrilla|Grilla], [Pista|RestoPista], [ColumnaSalida|RestoSalida],L,Indice):-
		IndiceAux is Indice +1,
		esListaConUnicaSol(Pista, PrimerColumnaGrilla),
		solucionUnicaFila(PrimerColumnaGrilla, Pista, L, ColumnaSalida), 
		resolverColumnaTrivial(Grilla, RestoPista, RestoSalida, L, IndiceAux).
		

	resolverColumnaTrivial([PrimerColumnaGrilla|Grilla], [_Pista|RestoPista], [PrimerColumnaGrilla|RestoGrilla],Lpc,Indice):-
		resolverColumnaTrivial(Grilla, RestoPista, RestoGrilla, Lpc, Indice).

	%%%%%%%%%%%%%%%%%%%%%%%%
	
	solucionGrilla(GrillaOriginal,PistasFilas,PistasColumnas,GrillaNueva):-
		length(PistasFilas, LongFilas),
		length(PistasColumnas,LongColumnas),
	(   LongColumnas \== LongFilas ->  primeraPasada(GrillaOriginal, PistasFilas, PistasColumnas,LongColumnas,LongFilas, GrillaResultante), solucionGrillaAux(GrillaResultante, LongColumnas,LongFilas,PistasFilas,PistasColumnas,SolucionAux);
		primeraPasada(GrillaOriginal, PistasFilas, PistasColumnas,LongFilas,LongColumnas, GrillaResultante),
		solucionGrillaAux(GrillaResultante, LongFilas,LongColumnas,PistasFilas,PistasColumnas,SolucionAux)),
		columnas(SolucionAux, LongFilas, [] , Grilla),
		chequear(Grilla,N), %mira si hay espacios vacios
		hastaCompletar(N, Grilla, LongFilas, LongColumnas, PistasFilas, PistasColumnas,GrillaNueva).
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	solucionGrillaAux(GrillaOriginal,LongFilas,LongColumnas, PistasFilas,PistasColumnas,SolucionAux):-
		solucionFilas(GrillaOriginal, LongFilas, PistasFilas,SolAux),
		solucionColumna(SolAux, LongColumnas, PistasColumnas,SolucionAux).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	allAtomico([]).
	allAtomico([Elem|Lista]):-
		forall(member(E,Elem), (E == "#"; E == "X")),
		allAtomico(Lista).
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	chequear([Fila|Grilla] , N):-
		allAtomico(Fila),
		chequear(Grilla,N).
	chequear([],0).
	chequear(_Fila, 1). %encontre lugar vacio

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	hastaCompletar(N, Grilla, LongFilas, LongColumnas, PistasFilas, PistasColumnas, SolucionFinal):-
	(     N \==1 -> SolucionFinal = Grilla, !;
	solucionFinal(Grilla, LongFilas, LongColumnas, PistasFilas, PistasColumnas, Aux),
	chequear( Aux, M),
	hastaCompletar(M, Aux, LongFilas, LongColumnas, PistasFilas, PistasColumnas,  SolucionFinal)).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

	solucionFinal(Grilla, LongFilas, LongColumnas ,PistasFilas, PistasColumnas, SolucionFinal):-
		pasadaFinal(Grilla, PistasFilas, GrillaNuevaA),
		columnas(GrillaNuevaA,LongColumnas,[], GrillaCol),
		pasadaFinal(GrillaCol, PistasColumnas,SolAux),
		columnas(SolAux, LongFilas,[], SolucionFinal).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	pasadaFinal(Grilla, PistasFila, Solucion):-
		pasadaFinalAux( Grilla, PistasFila, [], Solucion).

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% caso base
	pasadaFinalAux(  [] ,[], ListaAux, ListaAux).
		
	%% Caso: Fila completa
	pasadaFinalAux(  [Fila|Grilla] , [_P|PistasFila], ListaAux, Solucion):-
		allAtomico(Fila),
		append(ListaAux, [Fila], ListaAux2),
		pasadaFinalAux( Grilla, PistasFila, ListaAux2, Solucion).

	%% Caso: Fila incompleta
	pasadaFinalAux(  [Fila|Grilla] , [Pista|PistasFila], ListaAux, Solucion):-
		length(Fila,N),
		solucionUnicaFila(Fila,Pista, N, Resultado),
		append(ListaAux, [Resultado], ListaAux2),
		pasadaFinalAux(Grilla,PistasFila, ListaAux2, Solucion).
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%