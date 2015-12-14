function [gathered_knowldeges, sum_knowledge] = collect_attributes(gathered_knowledges, gathered_sir_states, S, t)
[ sum_knowledge, sir_state ] = get_attributes( S, t );
gathered_knowldeges = [gathered_knowldeges sum_knowledge];
sum_knowledge = [gathered_sir_states sir_state];

end