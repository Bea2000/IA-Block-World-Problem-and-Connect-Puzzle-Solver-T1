% B X X X F X D
% X X X X X X X
% X X A X X X E
% X X C X X X X
% X X C X X X E
% X X B X X X X
% X A X X F X D

fila(1..7).
columna(1..7).

% Definir puntos iniciales
color(blue,1,1).
color(blue,7,1).
color(red,3,3).
color(red,7,2).
color(yellow,1,2).
color(yellow,7,3).
color(green,7,4).
color(green,5,6).
color(purple,1,3).
color(purple,7,7).
color(orange,1,6).
color(orange,1,7).

% podemos definir los colores de la siguiente manera
opcion_color(C) :- color(C,Y,X).

% podemos definir celda(X, Y, C) como un predicado que nos dice que la celda (X,Y) tiene el color C
% por cada fila y columna, hay una celda con un color
1{celda(Y,X,C): opcion_color(C)}1 :- fila(X), columna(Y).

% las celdas de casos iniciales y finales de cada color deben estar con dicho color
celda(Y,X,C) :- color(C,Y,X).

% definimos aledanos como dos celdas que se encuentran aledanas
aledanos(C,Y,X,Y2,X2) :- Y=Y2+1, X=X2, celda(Y2,X2,C), celda(Y,X,C).
aledanos(C,Y,X,Y2,X2) :- Y=Y2-1, X=X2, celda(Y2,X2,C), celda(Y,X,C).
aledanos(C,Y,X,Y2,X2) :- Y=Y2, X=X2-1, celda(Y2,X2,C), celda(Y,X,C).
aledanos(C,Y,X,Y2,X2) :- Y=Y2, X=X2+1, celda(Y2,X2,C), celda(Y,X,C).

% definimos no_extremo como una celda que no es el origen ni el destino
no_extremo(C,Y,X) :- celda(Y,X,C), not color(C,Y,X).
% cada celda debe tener dos aledanos a excepcion de si es el origen o el destino
2{ camino(C,Y,X,Y2,X2) : aledanos(C,Y,X,Y2,X2) }2 :- no_extremo(C,Y,X).
% las celdas que son origen o destino deben tener 1 aledano
1{ camino(C,Y,X,Y2,X2) : aledanos(C,Y,X,Y2,X2) }1 :- color(C,Y,X).

% los caminos no pueden dirigirse al mismo punto
:- camino(C,Y,X,Y,X).

% todos los caminos son no dirigidos
:- camino(C,Y,X,Y2,X2), not camino(C,Y2,X2,Y,X).

% todas las celdas deben estar asociadas a un camino
:- celda(Y,X,C), not camino(C,Y,X,_,_).
