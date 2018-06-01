:- module('find_repetitive_condition.analysis', [
          find_repetitive_condition/3
          ]).
 %
 % Analysis of Repeatative Condition :
 %  
 
    
 find_repetitive_condition(CompleteCondition,FirstOccurrence,RepetitiveCondition) :-
	conditional_statement(CompleteCondition),
    flatten_expression(CompleteCondition,_,AllTests),
    non_redundant_pair_to_be_compared(AllTests,FirstOccurrence,RepetitiveCondition),
    same_structure(FirstOccurrence,RepetitiveCondition).
    
 


% Extract from AllTests pairs of elements to be compared.
% start with the leftmost element to be compared to each 
% element further right. Then continue recursively with 
% extracting pairs from the elements on the right.
% This way we avoid comparing the same two elements twice.
non_redundant_pair_to_be_compared(AllTests,Element,RHSElement) :-
    split(AllTests, Element, RHSElementList),
    member(RHSElement,RHSElementList).


%%  split(FullList, Element, ListAfterElement) :- 
 

split([X|Rest],X,Rest).

split([_|Rest],Elem,NewRest) :-
     split(Rest,Elem,NewRest).

%% flatten_expression(+Expr,-Operator,?FlatRest) is det
%% flatten_expression(+Expr,+Operator,?FlatRest) is det
%
% The toplevel call typically has the second argument free 
% since in general one want to flatten everything. The 
% recursive calls have the second argumetn bound since 
% one has to make sure that one only flattens subconditons
% of the same operator and does not mix subconditions that
% are connected by different operators (e.g. && and ||).
flatten_expression(Expr,Operator,FlatRest) :- 
   (  condition(Expr,_,_,LHS,Operator,RHS)
   -> (flatten_expression(LHS,Operator,FlatLeft),
       flatten_expression(RHS,Operator,FlatRight),
       append(FlatLeft,FlatRight,FlatRest)
      )
   ;  FlatRest = [Expr]
   ),
   !. 

  
   
	
 
conditional_statement(Condition) :-
   ( ifT(ConditionalStatement,_,MethodT,Condition,_,_)
   ; whileT(ConditionalStatement,_,MethodT,Condition,_)
   ; doWhileT(ConditionalStatement,_,MethodT,Condition,_)
   ).
   

condition(Condition,Parent,MethodT,LHS,Operator,RHS) :-
    operationT(Condition,Parent,MethodT,[LHS,RHS], Operator,_),
    repeatable_conditional_operator(Operator).
    
    
%% Enumerate operators that can have repeated arguments
repeatable_conditional_operator('&&').
repeatable_conditional_operator('||').
repeatable_conditional_operator('&').
repeatable_conditional_operator('|').



% Same structure = two operationT elements with the same operator 
% and with left-hand-sides that have the same structre (recursively)
% and with right-hand-sides that have the same structure.
same_structure(null,null) :-!.

same_structure(LHS,RHS) :- 
	 operationT(LHS,_,Method,[LeftLHSNested, LeftRHSnested], Operator,_),
	 operationT(RHS,_,Method,[RightLHSNested,RightRHSnested],Operator,_),
	 same_structure(LeftLHSNested, RightLHSNested),
	 same_structure(LeftRHSnested, RightRHSnested).

same_structure(LHS,RHS) :- 
	fieldAccessT(LHS,_,_,Obj1,Field,_),
	fieldAccessT(RHS,_,_,Obj2,Field,_),
    same_structure(Obj1,Obj2).

	
same_structure(LHS,RHS) :- 
	identT(LHS,_,_,Local),
	identT(RHS,_,_,Local).
 
same_structure(LHS,RHS) :- 
	literalT(LHS,_,_,_,Value),
	literalT(RHS,_,_,_,Value).	
	

conditional_operator('>'). 
conditional_operator('<').   
conditional_operator('>='). 
conditional_operator('<=').    
conditional_operator('==').     
conditional_operator('!=').     
    
    
 %Tranformation   
:- multifile user:ct/3. % (Head, Condition, Transformation) 

%% delete_repetitive_condition(+RepetitiveCondition)
% 
% This CT deletes a repetitive condition that has one sibling
% in the operationT representation. It is still possible that it has 
% many siblings in the complete condition in which it occurs as a subcondition.

user:ct(delete_repetitive_condition(RepetitiveCondition),(
          'find_repetitive_condition.analysis':(
                 find_repetitive_condition(Condition,_,RepetitiveCondition),
                 ast_parent(RepetitiveCondition,P),
                 % The repetitive condition has exactly one sibling:
                 operationT(P,GP,_,[LHS,RHS],_,0),
                 ( LHS == RepetitiveCondition, Sibling = RHS
                 ; RHS == RepetitiveCondition, Sibling = LHS
                 ),
                 % let_grandparent_refer_to_sibling:
                 get_term(GP,GrandParentTerm), 
                 replace_value_in_term(GrandParentTerm, P, Sibling, NewGrandParentTerm),
                 % set grandparent as new parent of sibling
                 get_term(Sibling,SiblingTerm), 
                 replace_value_in_term(SiblingTerm, P, GP, NewSiblingTerm)
          )
),
(   % 1. Delete the repetitve condition (and all its children)
    % 2. Delete its parent (but keep its child, the sibling of the repetitive cond)
    % 3. Let the parent reference of the sibling point to the grandparent
    % 4. Let the child reference of the grandparent point to the sibling 
	deepDelete(RepetitiveCondition),
	delete( operationT(P,_,_,_,_,_)),
	replace(GrandParentTerm, NewGrandParentTerm),
	replace(SiblingTerm, NewSiblingTerm)
)).



