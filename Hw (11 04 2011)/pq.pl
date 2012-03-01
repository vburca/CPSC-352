/* pq.pl -- priority queue copied from Luger and Stubblefield */

empty_queue([]).

enqueue(E,[],[E]).
enqueue(E,[H|T],[H|Tnew]) :- enqueue(E,T,Tnew).

dequeue_pq(E,[E|T],T).
dequeue_pq(E,[E|T],_). /* peek */


add_list_to_queue(List,Queue,NewQ):-
	append(Queue,List,NewQ).

empty_pq([]).

member_pq(E,Q) :- member(E,Q).

insert_pq(State,[],[State]).
insert_pq(State,[H|Tail],[State,H|Tail]) :-
	precedes(State,H),!.
insert_pq(State,[H|T],[H|Tnew]) :-
	insert_pq(State,T,Tnew).

insert_list_pq([],L,L).
insert_list_pq([State|Tail],L,New_L) :-
	insert_pq(State,L,L2),
	insert_list_pq(Tail,L2,New_L).

/** precedes(X,Y) :- X < Y.  **/
