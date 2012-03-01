% Author: Vlad Burca
% Date: 10-04-2011
% File : part2.pl

%
family([dana,stefan],[[],[vlad]]).
family([gabriela,mihai],[[raluca],[]]).
family([alina,dragos],[[iulia],[]]).

family([maria,sstefan],[[],[stefan,dragos]]).
family([aalina,ddragos],[[],[sstefan]]).
family([florita,vasile],[[maria],[]]).

family([aurora,victor],[[dana,gabriela],[]]).
family([ggabriela,mmihai],[[],[victor]]).
family([ana,lica],[[aurora],[]]).


father_of(D,C) :- family([_,D],[Ds,Ss]), (member(C,Ds); member(C,Ss)).
mother_of(M,C) :- family([M,_],[Ds,Ss]), (member(C,Ds); member(C,Ss)).
parent_of(P,C) :- father_of(P,C); mother_of(P,C).

male(M) :- family([_,M],_).
male(M) :- family(_,[_,Ss]), member(M,Ss).
female(F) :- family([F,_],_).
female(F) :- family(_,[Ds,_]), member(F,Ds).

son_of(C,P) :- parent_of(P,C), male(C).
daughter_of(C,P) :- parent_of(P,C), female(C).

sibling_of(C1,C2) :- parent_of(P,C1), parent_of(P,C2), C1\==C2.
brother_of(C1,C2) :- sibling_of(C1,C2), male(C1).
sister_of(C1,C2) :- sibling_of(C1,C2), female(C1).

grandparent_of(G,PR) :- parent_of(G,P), parent_of(P,PR).
ancestor_of(A,PR) :- parent_of(A,PR).
ancestor_of(A,PR) :- parent_of(A,P), ancestor_of(P,PR).

oldest_son(S,P) :- parent_of(P,S), family(_,[_,[S|_]]).
oldest_daughter(D,P) :- parent_of(P,D), family(_,[[D|_],_]).
