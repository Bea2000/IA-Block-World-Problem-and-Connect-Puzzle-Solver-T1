tiempo(0..bound).

%definimos n robots
brazorobot(1..n).

% Tenemos 8 bloques
bloque(1..8).

% cada bloque está en un lugar
lugar(X) :- bloque(X).
% definimos una mesa
lugar(mesa).

% En cada tiempo t cada robot puede ejecutar a lo más un movimiento posible
0{ejecutar(X,Y,T,R) : movimientoposible(X,Y,T)}1 :- tiempo(T), T!=bound, brazorobot(R).

% dos robots no pueden mover el mismo bloque
:- ejecutar(X,Y,T,R1), ejecutar(X,Z,T,R2), R1!=R2.

% dos robots no pueden mover hacia el mismo lugar a excepción de la mesa
:- ejecutar(X,Y,T,R1), ejecutar(Z,Y,T,R2), R1!=R2, Y!=mesa.

% Un robot no puede mover un bloque a otro bloque que está moviendo otro robot
:- ejecutar(X,Y,T,R1), ejecutar(Z,X,T,R2), R1!=R2.

% X es desde donde se origina el moivimiento e y es hacia donde se mueve
origen_movimiento(X,T) :- ejecutar(X,Y,T,R).
destino_movimiento(Y,T) :- ejecutar(X,Y,T,R).

% si X está sobre Y en el tiempo t y X no fue donde se origina el movimiento en t, entonces X está sobre Y en el tiempo t+1
sobre(X,Y,T+1) :-
	tiempo(T),
	sobre(X,Y,T),
	not origen_movimiento(X,T).

% si se ejecute X,Y en un tiempo t, entonces el bloque X está sobre el lugar Y en el tiempo t+1
sobre(X,Y,T+1) :- 
	bloque(X),lugar(Y),tiempo(T),
	ejecutar(X,Y,T,R).

% si el bloque Y tiene un bloque X en t encima entonces está tapado
bloquetapado(Y,T) :- sobre(X,Y,T), tiempo(T).
% si X no está tapado en t, entonces está libre
bloquelibre(X,T) :- bloque(X), tiempo(T), not bloquetapado(X,T).

% si X no está sobre Y en el tiempo t y ambos están libres, entonces se puede mover X a Y
movimientoposible(X,Y,T) :- bloquelibre(X,T), bloquelibre(Y,T), X!=Y, not sobre(X,Y,T).
% si X está libre en el tiempo t, entonces se puede mover a la mesa
movimientoposible(X,mesa,T) :- bloquelibre(X,T), not sobre(X,mesa,T).

% todos los bloques tienen que haber llegado a su objetivo en el tiempo bound
:- not objetivo(bound).

% Condiciones iniciales (en el tiempo 0)
sobre(1, mesa, 0).
sobre(2, mesa, 0).
sobre(3, 1, 0).
sobre(4, 2, 0).
sobre(5, 3, 0).
sobre(6, mesa, 0).
sobre(7, mesa, 0).
sobre(8, 6, 0).


% Objetivo
objetivo(T) :-
	sobre(1, 4, T),
	sobre(2, 5, T),
	sobre(3, 6, T),
	sobre(4, 7, T),
	sobre(5, 8, T),
	sobre(6, mesa, T),
	sobre(7, mesa, T),
	sobre(8, mesa, T).

#show ejecutar/4.