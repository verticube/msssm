function [ M ] = metrics_init( P )
%METRICS_INIT Initializes metrics for checking and analysis.


%
% Totals over the entire population for different runs and steps:
%
M.numSusceptible = zeros(P.Simulation.numSteps,P.Simulation.numRuns);
M.numInfected    = zeros(P.Simulation.numSteps,P.Simulation.numRuns);
M.numRecovered   = zeros(P.Simulation.numSteps,P.Simulation.numRuns);


end
