% noun phrase
noun_phrase(T0,T3,Obj,C0,C3) :-
    det(T0,T1,Obj,C0,C1),
    adjectives(T1,T2,Obj,C1,C2),
    noun(T2,T3,Obj,C2,C3).

% negative noun phrase
noun_phrase_neg(T0,T3,Obj,C0,C3) :-
    det(T0,T1,Obj,C0,C1),
    adjectives_neg(T1,T2,Obj,C1,C2),
    noun_neg(T2,T3,Obj,C2,C3).

% verb phrase
verb_phrase(T0,T2,Obj,C0,C2) :-
    verb(T0,T1,Obj,C0,C1),
    noun_phrase(T1,T2,Obj,C1,C2).

% negative verb phrase
verb_phrase_neg(T0,T2,Obj,C0,C2) :-
    verb(T0,T1,Obj,C0,C1),
    noun_phrase_neg(T1,T2,Obj,C1,C2).

% determinants
det([the|T],T,_,C,C).
det([a|T],T,_,C,C).
det(T,T,_,C,C).

% adjectives used to define "cheap", "moderate",
% and "expensive" price relation
adjectives(T,T,_,C,C).
adjectives(T0,T2,Obj,C0,C2) :-
    adj(T0,T1,Obj,C0,C1),
    adjectives(T1,T2,Obj,C1,C2).

adj([cheap|T],T,Res,C,[prop(Res,name),
                       prop(Res,serves)|C]) :-
    prop(Res,price,cheap).
adj([moderate|T],T,Res,C,[prop(Res,name),
                          prop(Res,serves)|C]) :-
    prop(Res,price,moderate).
adj([expensive|T],T,Res,C,[prop(Res,name),
                           prop(Res,serves)|C]) :-
    prop(Res,price,expensive).
% adjectives used to define the type relation
adj([fast|T],T,Res,C,[prop(Res,name),
                      prop(Res,serves)|C]) :-
    prop(Res,type,fast).
adj([cafe|T],T,Res,C,[prop(Res,name),
                      prop(Res,serves)|C]) :-
    prop(Res,type,cafe).
adj([western|T],T,Res,C,[prop(Res,name),
                         prop(Res,serves)|C]) :-
    prop(Res,type,western).
adj([japanese|T],T,Res,C,[prop(Res,name),
                          prop(Res,serves)|C]) :-
    prop(Res,type,japanese).

% adjectives_neg used to define the negation of the adjectives
% adjectives used to define "cheap", "moderate",
% and "expensive" price relation
adjectives_neg(T,T,_,C,C).
adjectives_neg(T0,T2,Obj,C0,C2) :-
    adj_neg(T0,T1,Obj,C0,C1),
    adjectives_neg(T1,T2,Obj,C1,C2).

adj_neg([cheap|T],T,Res,C,[prop(Res,name),
                       prop(Res,serves)|C]) :-
    prop(Res,price,_),
    \+prop(Res,price,cheap).
adj_neg([moderate|T],T,Res,C,[prop(Res,name),
                          prop(Res,serves)|C]) :-
    prop(Res,price,_),
    \+prop(Res,price,moderate).
adj_neg([expensive|T],T,Res,C,[prop(Res,name),
                           prop(Res,serves)|C]) :-
    prop(Res,price,_),
    \+prop(Res,price,expensive).
% adjectives used to define the type relation
adj_neg([fast|T],T,Res,C,[prop(Res,name),
                      prop(Res,serves)|C]) :-
    prop(Res,type,_),
    \+prop(Res,type,fast).
adj_neg([cafe|T],T,Res,C,[prop(Res,name),
                      prop(Res,serves)|C]) :-
    prop(Res,type,_),
    \+prop(Res,type,cafe).
adj_neg([western|T],T,Res,C,[prop(Res,name),
                         prop(Res,serves)|C]) :-
    prop(Res,type,_),
    \+prop(Res,type,western).
adj_neg([japanese|T],T,Res,C,[prop(Res,name),
                          prop(Res,serves)|C]) :-
    prop(Res,type,_),
    \+prop(Res,type,japanese).

% noun food is a general word used to refer to all types of food
noun([food|T],T,_,C,C).
% noun queries for the restauarant that have the Food
noun([Food|T],T,Res,C,[prop(Res,name),
                       prop(Res,serves)|C]) :-
    prop(Res,serves,Food),
    \+member(prop(Res,name),C).

% noun_neg matches restaurants that do not have the food
noun_neg([food|T],T,_,C,C).
noun_neg([Food|T],T,Res,C,[prop(Res,name),
                           prop(Res,serves)|C]) :-
    prop(Res,type,_),
    \+prop(Res,serves,Food),
    \+member(prop(Res,name),C).
    
% verb
verb([to,eat|T],T,_,C,C).
% no verbs like to eat just assumes eating
verb(T,T,_,C,C).

% user_input 
% for the affirmative phrase, we can simply query the knowledge
% base with the object that matches the food that is passed in.
% Obj is the restaurant that serves the food.
user_input([i,like|T0],T1,Obj,C0,C1) :-
    verb_phrase(T0,T1,Obj,C0,C1).
user_input([i,want|T0],T1,Obj,C0,C1) :-
    verb_phrase(T0,T1,Obj,C0,C1).
% for the negative phrase, we need to take the Obj returned from
% the user and query for all restaurants not matching
user_input([i,do,not,like|T0],T1,Obj,C0,C1) :-
    verb_phrase_neg(T0,T1,Obj,C0,C1).
user_input([i,do,not,want|T0],T1,Obj,C0,C1) :-
    verb_phrase_neg(T0,T1,Obj,C0,C1).

% restauarant_id_from_query is true if list A is the name of restauarant with id RestauarantId
restauarant_id_from_query(S, A, RestauarantId, S) :-
    atomic_list_concat(A, ' ', Name),
    prop(RestauarantId, name, Name).

restauarant_id_from_query([H|T], A, RestauarantId, RestS) :- 
    append(A, [H], NewA),
    restauarant_id_from_query(T, NewA, RestauarantId, RestS).

% Restauarant serves Food
state(S) :- 
    restauarant_id_from_query(S, [], RestauarantId, [serves|[V|_]]),
    add_rule(prop, RestauarantId, serves, V).

% Restauarant no longer serves Food
state(S) :- 
    restauarant_id_from_query(S, [], RestauarantId, [no, longer, serves|[V|_]]),
    remove_rule(prop, RestauarantId, serves, V).

% Restauarant has closed down
state(S) :- 
    restauarant_id_from_query(S, [], RestauarantId, [has, closed, down]),
    remove_rule(prop, RestauarantId, _, _).

% state(["Pizza", "Hut", serves, burger]).
% state(["Pizza", "Hut", no, longer, serves, burger]).
% state(["Pizza", "Hut", has, closed, down]).


% ask
% Since C is a list of relations on individuals, 
% we use prove_all to execute the queries
% example: ?- ask([i,like,to,eat,seafood],Res,Food).
ask(Q,Alias,Food) :-
    user_input(Q,[],_,[],C),
    prove_all(C,[Alias,Food]).
    
% prove all
% iterates through the list of queries and variables
% and calls the queries with the corresponding variables
prove_all([],[]).
prove_all([Q|QT],[V|VT]) :-
    call(Q,V),
    prove_all(QT,VT).

add_rule(Predicate, X, Y, Z) :-
    Fact =.. [Predicate, X, Y, Z],
    assertz(Fact).

remove_rule(Predicate, X, Y, Z) :-
    Fact=.. [Predicate, X, Y, Z],
    retract(Fact).

% Knowledge base
prop(mcdonald, type, fast).
prop(mcdonald, name, 'McDonalds').
prop(mcdonald, serves, burgers).
prop(mcdonald, serves, fries).
prop(mcdonald, serves, icecream).
prop(mcdonald, price, cheap).

prop(starbucks, type, cafe).
prop(starbucks, name, 'Starbucks').
prop(starbucks, serves, coffee).
prop(starbucks, serves, cookie).
prop(starbucks, price, moderate).

prop(pizzahut, type, fast).
prop(pizzahut, name, 'Pizza Hut').
prop(pizzahut, serves, pizza).
prop(pizzahut, price, moderate).

prop(sage, type, western).
prop(sage, name, 'Sage Bistro').
prop(sage, serves, seafood).
prop(sage, serves, burgers).
prop(sage, price, expensive).

prop(bento_sushi, type, japanese).
prop(bento_sushi, name, 'Bento Sushi').
prop(bento_sushi, serves, sushi).
prop(bento_sushi, serves, ramen).
prop(bento_sushi, price, moderate).