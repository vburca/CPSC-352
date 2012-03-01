/* bf.pl -- best first search shell copied from Luger and Stubblefield. 

    Note that in this version a state is represented by 5-tuple with
    the following elements: 

         State_ID:  For Knight's Tour this would be the number of the square
         Parent_ID: For Knight's Tour tthis would be the number of the square
         Depth:  This is g(n)
         Heuristic: This is h(n)
         Sum: This is f(n)= g(n) + h(n)

    For example, if you are starting a tour from square 1, this would be
    represented as [1,nil,0,0,0]. If you do move(1,6), then this would lead
    to a state represented as [6,1,1,0,1]. Note that the heuristic value
    is always 0 (breadth-first search), so f(n) = g(n).

*/

/* The go/2 predicate is the main predicate. It initializes the open and closed lists
   used in best-first and invokes the path/3 predicate to construct a solution
   path. 
*/

go(Start,Goal) :-                  %% Go from the Start to the Goal state. 
	empty_set(Closed_set),          %% Init the closed set -- i.e., visited states 
	empty_pq(Open),                 %% Init the open list
	heuristic(Start,Goal,H),        %% Init the heuristic value of Start state
	insert_pq([Start,nil,0,H,H],Open,Open_pq),  %% Insert the Start state on open list
	path(Open_pq,Closed_set,Goal).  %% Recursively find a path to the Goal state.

/* The path/3 predicate performs a recursive best-first search. One base case
   occurs when the Open list is empty, indicating no further states remain to
   be searched. A second base case occurs when the first state on the priority
   queue equals the Goal state. 

   In recursive rule all of the children of the first state on the
   priority queue are prioritized and added to the PQ.  The search
   proceeds to the child with the lowest f(n). If h(n) is 0 for all
   states, best-first degenerates to breadth-first.
*/

path(Open,_,_) :-               %% Base case: Failure if Open list is empty
	empty_pq(Open),
	write('Graph searched, no solution found.').

path(Open_pq,Closed_set,Goal) :-
	dequeue_pq([State,Parent,_,_,P],Open_pq,_),
	State = Goal,                               %% Base case: Success.
	write('The solution path is: '),nl,
	printsolution([State,Parent,_,_,_],Closed_set).

/* The recursive version of path/3 removes the first State from the Open list.
   It then retrieves all of that state's children and places then on the Open list
   in priority order. It then places State on the closed list and recurses.
*/

path(Open_pq,Closed_set,Goal) :-                                        %% Recursive case
	dequeue_pq([State,Parent,D,H,S],Open_pq,Rest_open_pq),          %% Remove first State
	get_children([State,Parent,D,H,S],Rest_open_pq,Closed_set,Children,Goal), %% Get its children
	writelist(['Trying ',State,' Depth = ',D,' H=',H]),nl,    
	insert_list_pq(Children,Rest_open_pq,New_open_pq),                 %% Insert children into Open
	add_if_not_in_set([State,Parent,D,H,S],Closed_set,New_closed_set), %% Insert State into closed
	path(New_open_pq,New_closed_set,Goal).                             %% Recurse to Goal

/*
 The get_children/5 predicate uses PROLOG's bagof/3 predicate to collect all
 the children of the current state. The bagof/3 predicate creates a list
 from all the unifications of a pattern. The second parameter is the
 pattern predicate (moves) that will be matched in the database. The
 first parameter specifies the components (Child) of the second parameter that
 will be collected together in the list.  In this case, bagof/3 collects
 the children of State by firing all of the move(State,_) predicates.
*/

get_children([State,_,D,_,_],Rest_open_pq,Closed_set,Children,Goal) :-
	bagof(Child,  moves([State,_,D,_,_],Rest_open_pq,Closed_set,Child,Goal), Children).

/************************* 
  This problem was described in the text: In our implementation of
  PROLOG, the bagof predicate fails when no matches exist for the
  second argument. That's why this additional predicate is needed. 
*************************/

get_children([State,_,D,_,_],Rest_open_pq,Closed_set,[],Goal) :-
	not(bagof(Child,moves([State,_,D,_,_],Rest_open_pq,
	          Closed_set,Child,Goal),Children)).

/* 
 The moves/5 predicate constructs a list of safe moves from the current
 state. Note that it checks both the Open list and the Closed list and
 it sets g(n), h(n), and f(n) for the child.  It is based on the
 assumption that the basic moves of the search space take the form move(X,Y).
*/

moves([State,_,Depth,_,_],Rest_open_pq,Closed_set,[Next,State,New_D,H,S],Goal) :-
	move(State,Next),        
	not(unsafe(Next)),
	not(member_pq([Next,_,_,_,_],Rest_open_pq)),
	not(member_set([Next,_,_,_,_],Closed_set)),
	New_D is Depth + 1,
	heuristic(Next,Goal,H),
	S is New_D + H.

/* The printsolution/2 predicate traces through the State/Parent
   relationships in reverse order, printing the State.
*/

printsolution([State,nil,_,_,_],_) :-
	write(State),nl.

printsolution([State,Parent,_,_,_],Closed_set) :-
	member_set([Parent,Grandparent,_,_,_],Closed_set),
	printsolution([Parent,Grandparent,_,_,_],Closed_set),
	write(State),nl.
	
               
writelist([]).
writelist([H|T]) :- write(H),writelist(T).

 


