function [ M ] = metrics_init( s, S, M, t )
%METRICS_UPDATE Updates metrics during simulation.


%
% Totals over the entire population in current run/step:
%
M.numSusceptible(t,s) = length(find(S.Disease.susceptible));
M.numInfected(t,s)    = length(find(S.Disease.infected));
M.numRecovered(t,s)   = length(find(S.Disease.recovered));

%
% Mean over numbers of infections caused by single node
%
numEverInfected = S.Topology.numNodes-M.numSusceptible(t,s);
M.meanR0(t,s) = sum(S.Disease.infections)/numEverInfected;


end
