function S = sim_pat0( DEBUG, S )
%SIM_PAT0 Infects Patient Zero at t = 1, assigns to SIR.


node_pat0 = 1; % Which node on to infect first?


if DEBUG, fprintf('>> Infecting %d\n', node_pat0); end


%
% Assign Patient Zero to SIR compartments:
%
S.Disease.infected   (node_pat0) = 1; % t of infection
S.Disease.susceptible(node_pat0) = 0;

S.Disease.infections (node_pat0) = 1;


%
% Generate self-information with probability:
%
S = info_generate(DEBUG,S,S,1); % Note: C = S


end
