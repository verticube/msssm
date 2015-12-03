%
% Transmissionary
%
% Social discovery and its impact on the spreading of diseases
%
%
% @author Joris Cadow <cadowj@student.ethz.ch>
% @author Steffen Arnold <arnoldst@student.ethz.ch>
%
%
% Epidemiological model
%
% - Each individual (= node) assigned to exactly one compartment:
%   - S compartment: susceptible nodes can be infected
%   - I compartment: infected nodes can infect susceptible neighbors
%   - R compartment: recovered nodes do not contribute (anymore)
% - Disease spreads along contact network (= graph):
%   - Recovery probability of single node: I -> R
%   - Contact probability of neighbors: <IS>c -> <II>c
% - Disease characterized by graph and transition probabilities.
%
%
% Information network model
%
% - Information about infection spreads in information network:
%   - Generation probability about itself: I(!I) -> I(I)
%   - Propagation probability: <X(Z)Y(!Z)>i -> <X(Z)Y(Z)>i
% - Between each pair of two nodes following information exists:
%   - Distance the information needed to travel to recipient.
%   - Timestamp of when information arrived at recipient.
%   - Absence of information denoted by zero-valued timestamp.
% - All information in single node contributes to its "awareness".
% - Awareness of susceptible node modifies infection probabilty:
%     Prob(<IS>c -> <II>c) = probContact * (1 - Awareness(S))
%
%
% Notation
%
% <XY>c -> nodes X and Y are neighbors in the contact network
% <XY>i -> nodes X and Y are neighbors in the information network
% X(!Y) -> node X has no information about node Y's infection
% X( Y) -> node X does have information about node Y's infection
%


% profile on

DEBUG = false;


%%%
%%% Simulation Parameters
%%%

% Number of nodes in networks
P.Topology.numNodes =   9;

% Contact probability per timestamp
P.Disease.probContact = 1.00;
% Recovery probability per timestamp
P.Disease.probRecover = 1.00;

% Generation probability per timestamp
P.Information.probGenerate  = 1.00;
% Prpopagation probability per timestamp
P.Information.probPropagate = 1.00;

% Cutoff for information distance
P.Information.cutoffDistance = 3;
% Starting value for new awareness
P.Information.awarenessStart = 1;
% Decrease in awareness per timestep
P.Information.awarenessSlope = 1/1;
% Coefficient to information distance
P.Information.coeffDistance  = log(2);

% Random contact probability per timestep
P.Perturbation.probRandContact = 1.00;

% Number of independent runs
P.Simulation.numRuns =  10;
% Number of timesteps per run
P.Simulation.numSteps =  30;


M = metrics_init(P);

for s = 1:P.Simulation.numRuns

    fprintf('> Simulation %d\n', s);

    %RandStream.getGlobalStream

    S = sim_init(P,s);

    if DEBUG, fprintf('> Timestep t = 1\n'); end

    S = sim_pat0(DEBUG,S);
    M = metrics_update(s,S,M,1);

    for t = 2:P.Simulation.numSteps

        if DEBUG, fprintf('> Timestep t = %d\n', t); end

        S = sim_step(DEBUG,S,t);
        M = metrics_update(s,S,M,t);

    end

end


hold on
plot(mean(M.numInfected ,2)/P.Topology.numNodes)
plot(mean(M.numRecovered,2)/P.Topology.numNodes)
