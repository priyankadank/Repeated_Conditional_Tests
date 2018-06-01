
:- module('find_repetitive_condition',[]).   % (MethodT)

:- use_module(jt_analysis(make_result_terms), [ 
    make_result_term/3 % (RoleTerm, Description, Result)
]).

:- use_module('find_repetitive_condition.analysis', 
		     [find_repetitive_condition/3		% (MethodT) 
		     ]).  
		  		 
  
:- multifile(analysis_api:analysis_definition/6). % (Name, Trigger, Severity, Category, Description, QuickfixAvailable)
analysis_api:analysis_definition(
     'find_repetitive_condition',               % Name of the analysis, can be any atom
     onSave,                            	    % Run the analysis 'manually' from the Control Center
     warning,                           		% Severity, Marker to be displayed by Eclipse: error, since this is a 'correctness' bug
     'Correctness',                     	% Category in the JT Control Center. This is a 'correctness' bug
     'Repeated Conditional Test with (e.g., x == 0 || x == 0)', 	        % Description of the analysis
     true                       			% There is no Quickfix available (otherwise: true)
).
    

:- multifile(analysis_api:analysis_result/3).
 analysis_api:analysis_result(find_repetitive_condition, _,Result) :-
    find_repetitive_condition(_Condition,_Element,RHSElement),		% call the Repeated Contional test analysis
    format(atom(Description), 'The code contains a conditional test that is performed twice (e.g., x == 0 || x == 0). Perhaps the second occurrence is intended to be something else (e.g., x == 0 || y == 0).',[]),
  make_result_term(find_repetitive_condition(RHSElement), Description,Result).
     
     

:- multifile(transformation_api:transformation/5).     % Don't forget the declaration!
transformation_api:transformation(
     _,                                                 % Individual result (No group)
     find_repetitive_condition(Id),                  	% RoleTerm 
     [delete_repetitive_condition(Id)      
     ],                        
     'Delete the repeated condition',     				        % Description
     [global,preview]).    

    
