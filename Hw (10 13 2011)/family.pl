% Author: Vlad Burca
% Date: 10/14/2011
% File: family.pl

%
family([dana,stefan],[[vlad,male]]).
family([gabriela,mihai],[[raluca,female]]).
family([alina,dragos],[[iulia,female]]).

family([maria,sstefan],[[stefan,male],[dragos,male]]).
family([aalina,ddragos],[[sstefan,male]]).
family([florita,vasile],[[maria,female],[gheorghe,male]]).

family([aurora,victor],[[dana,female],[gabriela,female]]).
family([ggabriela,mmihai],[[victor,male]]).
family([ana,ggheorghe],[[aurora,female],[lica,male]]).

parent_of(P,C) :- family(Ps,Cs),member(P,Ps),member([C,_],Cs).
father_of(F,C) :- family([_,F],Cs),member([C,_],Cs).
mother_of(M,C) :- family([M,_],Cs),member([C,_],Cs).

ancestor_of(A,D) :- parent_of(A,D).
ancestor_of(A,D) :- parent_of(A,FD),ancestor_of(FD,D).

sibling_of(S1,S2) :- S1\==S2,family(_,Cs),member([S1,_],Cs),member([S2,_],Cs).
brother_of(BR,S) :- BR\==S,family(_,Cs),member([BR,male],Cs),member([S,_],Cs).
sister_of(SI,S) :- SI\==S,family(_,Cs),member([SI,female],Cs),member([S,_],Cs).

oldest_child(P,OC) :- family(Ps,[[OC,_]|_]),member(P,Ps).

oldest_son(P,OS) :- family(Ps,Cs),member(P,Ps),member([X,male],Cs),!,OS==X. 
oldest_daughter(P,OD) :- family(Ps,Cs),member(P,Ps),member([X,female],Cs),!,OD==X.


is_male(P,X) :- family(Ps,Cs),member([X,male],Cs),member(P,Ps).

number_of_children(P,N) :- family(Ps,Cs),member(P,Ps),length(Cs,N).
%number_of_sons(P,N) :- family(Ps,Cs),member(P,Ps),member([X,male],Cs),N is N - 1, N \== 0.
%number_of_daughters(P,N) :- 


