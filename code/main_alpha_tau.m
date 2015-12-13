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


num_nodes = 100;
num_runs = 50;
num_steps = 100;

probs_contact = 0.5;
probs_recovery = 0.2;
probs_generation = 1;
probs_propagation = 0:0.1:1;
probs_dating = 0:0.1:1;
coeffs_distance = [2]*log(2)/2;


num_parsets = 1 ...
  * length(probs_contact) ...
  * length(probs_recovery) ...
  * length(probs_generation) ...
  * length(probs_propagation) ...
  * length(probs_dating) ...
  * length(coeffs_distance) ...
  ;
num_rows = num_parsets * num_runs * num_steps;

data = zeros(num_rows, 1 + 2 + 3);
data_index = 1;

parsets = zeros(num_parsets, 1 + 6);
parsets_index = 1;


parset = 0;

for prob_contact = probs_contact
for prob_recovery = probs_recovery
for prob_generation = probs_generation
for prob_propagation = probs_propagation
for prob_dating = probs_dating
for coeff_distance = coeffs_distance

parset = parset + 1;
fprintf('Parameter Set %d/%d\n', parset, num_parsets);

parsets(parsets_index,:) = [ ...
    parset ...
    prob_contact ...
    prob_recovery ...
    prob_generation ...
    prob_propagation ...
    prob_dating ...
    coeff_distance ...
    ];
parsets_index = parsets_index + 1;

save ../data/parsets_alpha_tau.dat parsets -ascii


%%%
%%% Simulation Parameters
%%%

% Number of nodes in networks
P.Topology.numNodes = num_nodes;

% Contact probability per timestamp
P.Disease.probContact = prob_contact;
% Recovery probability per timestamp
P.Disease.probRecover = prob_recovery;

% Generation probability per timestamp
P.Information.probGenerate  = prob_generation;
% Prpopagation probability per timestamp
P.Information.probPropagate = prob_propagation;

% Cutoff for information distance
P.Information.cutoffDistance = 3;
% Starting value for new awareness
P.Information.awarenessStart = 1;
% Decrease in awareness per timestep
P.Information.awarenessSlope = 1/2;
% Coefficient to information distance
P.Information.coeffDistance  = coeff_distance;

% Random contact probability per timestep
P.Perturbation.probRandContact = prob_dating;

% Number of independent runs
P.Simulation.numRuns = num_runs;
% Number of timesteps per run
P.Simulation.numSteps = num_steps;


rng(0,'twister'); % Seed RNG statically


M = metrics_init(P);

for s = 1:P.Simulation.numRuns

    fprintf('> Simulation %d\n', s);

    S = sim_init(P,s);

    if DEBUG, fprintf('> Timestep t = 1\n'); end

    S = sim_pat0(DEBUG,S);
    M = metrics_update(s,S,M,1);


    data(data_index,:) = [ ...
        parset ...
        s ...
        1 ...
        M.numSusceptible(1,s) ...
        M.numRecovered(1,s) ...
        M.meanR0(1,s) ...
        ];
    data_index = data_index + 1;


    for t = 2:P.Simulation.numSteps

        if DEBUG, fprintf('> Timestep t = %d\n', t); end

        S = sim_step(DEBUG,S,t);
        M = metrics_update(s,S,M,t);


        data(data_index,:) = [ ...
            parset ...
            s ...
            t ...
            M.numSusceptible(t,s) ...
            M.numRecovered(t,s) ...
            M.meanR0(t,s) ...
            ];
        data_index = data_index + 1;

    end

end


save ../data/data_alpha_tau.dat data -ascii


end
end
end
end
end
end
