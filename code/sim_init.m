function [ S ] = sim_init( P, s )
%SIM_INIT Initializes simulation with parameters.


S = P; % Copy parameters into state


%
% Contact network along which the disease spreads:
%
S.Network.contact = network_generate(S.Topology.numNodes);

%
% Information network along which information spreads:
%
S.Network.info = S.Network.contact; % Just a clone


%
% States 1: SIR compartments (epidemiology)
%
% S.Disease.X(i)      -> timestamp of infection
% S.Disease.X(i) ~= 0 -> #i in compartment X
% S.Disease.X(i) == 0 -> otherwise, not infected
%
S.Disease.susceptible =  ones(S.Topology.numNodes,1);
S.Disease.infected    = zeros(S.Topology.numNodes,1);
S.Disease.recovered   = zeros(S.Topology.numNodes,1);

%
% Counter of infections caused by single node, R_0
%
S.Disease.infections  = zeros(S.Topology.numNodes,1);


%
% States 2: Information network of awareness
%
% Information that each node possibly has over another one.
%
% S.Information.X(i,j) -> information #i has over #j
% S.Information.timestamp(i,j) == 0 -> no information
%
S.Information.timestamps = zeros(S.Topology.numNodes);
S.Information.distances  = zeros(S.Topology.numNodes);


end
