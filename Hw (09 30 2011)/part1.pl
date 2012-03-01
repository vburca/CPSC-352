% Author: Vlad Burca
% Date: 09-30-2011
% File: part1.pl

% 
parent_of(stefan, vlad).
parent_of(dana, vlad).
parent_of(mihai, raluca).
parent_of(gabriela, raluca).
parent_of(dragos, iulia).
parent_of(alina, iulia).

parent_of(sstefan, stefan).
parent_of(maria, stefan).
parent_of(sstefan, dragos).
parent_of(maria, dragos).

parent_of(ddragos, sstefan).
parent_of(aalina, sstefan).

parent_of(florita, maria).
parent_of(vasile, maria).

parent_of(victor, dana).
parent_of(aurora, dana).
parent_of(victor, gabriela).
parent_of(aurora, gabriela).

parent_of(mmihai, victor).
parent_of(ggabriela, victor).

parent_of(lica, aurora).
parent_of(ana, aurora).

male(dragos).
male(vasile).
male(mmihai).
male(lica).
male(sstefan).
male(victor).
male(stefan).
male(dragos).
male(mihai).
male(vlad).

female(aalina).
female(florita).
female(ggabriela).
female(ana).
female(maria).
female(aurora).
female(dana).
female(gabriela).
female(alina).
female(raluca).
female(iulia).
% X is father of Y if X is parent of Y and X is male.
father_of(X,Y) :- parent_of(X,Y), male(X).

% X is mother of Y if X is parent of Y and X is female.
mother_of(X,Y) :- parent_of(X,Y), female(X).

% X is son of Y if Y is parent of X and X is male.
son_of(X,Y) :- parent_of(Y,X), male(X).

% X is daughter of Y if Y is parent of X and X is female.
daughter_of(X,Y) :- parent_of(Y,X), female(X).

% X is sibling of Y if Z is parent of X and Z is parent of Y.
% i.e. if both X and Y have the same parent, Z.
sibling_of(X,Y) :- parent_of(Z,X), parent_of(Z,Y).

% X is brother of Y if X is sibling of Y and X is male.
brother_of(X,Y) :- sibling_of(X,Y), male(X).

% X is sister of Y if X is sibling of Y and X is female.
sister_of(X,Y) :- sibling_of(X,Y), female(X).

% X is grandparent of Y if X is parent of Z and Z is parent of Y.
% i.e. X is grandparent of Y if X is the parent of the parent of Y.
grandparent_of(X,Y) :- parent_of(X,Z), parent_of(Z,Y).

% X is ancestor of Y if X is parent of Y.
% -- base case of recursion --
ancestor_of(X,Y) :- parent_of(X,Y).

% X is ancestor of Y if X is parent of Z and Z is ancestor of Y.
% -- recursive step --
ancestor_of(X,Y) :- parent_of(X,Z), ancestor_of(Z,Y).
