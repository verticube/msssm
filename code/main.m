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
%   - Infection probability of neighbors: <IS>c -> <II>c
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
% - Awareness of susceptible node modifies infection probability:
%     Prob(<IS>c -> <II>c) = ProbInfection * (1 - Awareness(S))
%
%
% Notation
%
% <XY>c -> nodes X and Y are neighbors in the contact network
% <XY>i -> nodes X and Y are neighbors in the information network
% X(!Y) -> node X has no information about node Y's infection
% X( Y) -> node X does have information about node Y's infection
%


%%%
%%% External Libraries
%%%

addpath('graphviz')


%%%
%%% Simulation Parameters
%%%

DEBUG = false;

% Number of nodes
P.Topology.numNodes =  36;

% Infection probability per timestamp
P.Disease.probInfect = 0.50;
% Recovery probability per timestamp
P.Disease.probRecover = 0.25;

% Generation probability per timestamp
P.Information.probGenerate  = 1.00;
% Prpopagation probability per timestamp
P.Information.probPropagate = 1.00;

% Number of independent runs
P.Simulation.numRuns =  50;
% Number of timesteps per run
P.Simulation.numSteps =  30;

% Timesteps since generation/propagation
% - with zero awareness
P.Information.numStepsZero =  1;
% - with non-zero awareness (see below)
P.Information.numStepsNonZero =  3;
% Magnitude of non-zero awareness (>= 0 && <= 1)
%   == 0 -> reduces to SIR model without info
%   == 1 -> inhibits new infections completely
P.Information.nonZeroAwareness = 1.00;
% Coefficient to information distance
P.Information.coeffDistance = 1.00;


%%%
%%% Data Structures
%%%

%
% Contact network along which the disease spreads
%
S.Network.contact = network_generate(P.Topology.numNodes);

%
% Information network along which the awareness spreads
%
S.Network.info = S.Network.contact;


%%%
%%% Simulation
%%%


%
% Metrics for checking and analysis
%

% Probability-based decisons
S.Debug.numInfect = 0;
S.Debug.numNoInfect = 0;
S.Debug.numRecover = 0;
S.Debug.numNoRecover = 0;
S.Debug.numGenerate = 0;
S.Debug.numNoGenerate = 0;
S.Debug.numPropagate = 0;
S.Debug.numNoPropagate = 0;

% Totals over the entire population
S.Metric.numInfected  = zeros(P.Simulation.numRuns,P.Simulation.numSteps);
S.Metric.numRecovered = zeros(P.Simulation.numRuns,P.Simulation.numSteps);


for sim = 1:P.Simulation.numRuns


    fprintf('> Simulation %d\n', sim);


    %%%
    %%% Data Structures
    %%%

    %
    % States 1: SIR compartments (epidemiology)
    %
    % S.Disease.X(i) == 1 -> #i in compartment X
    % S.Disease.X(i) == 0 -> otherwise
    %
    % Integrity constraints:
    % - One node must be assigned to exactly one compartment.
    %   @todo Enforce this integrity condition e.g. via function?
    %
    S.Disease.susceptible =  ones(1,P.Topology.numNodes);
    S.Disease.infected    = zeros(1,P.Topology.numNodes);
    S.Disease.recovered   = zeros(1,P.Topology.numNodes);

    %
    % States 2: Information network of awareness
    %
    % Information that each node possibly has over another one.
    %
    % S.Information.X(i,j) -> information #i has over #j
    % S.Information.timestamp(i,j) == 0 -> no information
    %
    S.Information.timestamp = zeros(P.Topology.numNodes,P.Topology.numNodes);
    S.Information.distance  = zeros(P.Topology.numNodes,P.Topology.numNodes);


    %%%
    %%% Simulation
    %%%


    %
    % Timestep T = 1
    %
    % Start with "Patient Zero"
    %

    if DEBUG, fprintf('> Timestep T = 1\n'); end

    node_pat0 = 1;

    if DEBUG, fprintf('>> Infecting Patient Zero %d\n', node_pat0); end

    % Reassign Patient Zero to compartments
    S.Disease.infected(node_pat0)    = 1;
    S.Disease.susceptible(node_pat0) = 0;


    S.Metric.numInfected(sim,1)  = 1;
    S.Metric.numRecovered(sim,1) = 0;


    %
    % Simulate following timesteps
    %
    for t = 2:P.Simulation.numSteps


        % Create working copies of last states
        C.Disease.susceptible   = S.Disease.susceptible;
        C.Disease.infected      = S.Disease.infected;
        C.Disease.recovered     = S.Disease.recovered;
        C.Information.timestamp = S.Information.timestamp;
        C.Information.distance  = S.Information.distance;


        % Iterate through the infected nodes
        for node_infected = find(S.Disease.infected)

            % Does this node have information about his infection?
            if (C.Information.timestamp(node_infected,node_infected) == 0)
                if DEBUG, fprintf('>> Generate info about %d?\n', node_infected); end
                if (rand <= P.Information.probGenerate)
                    C.Information.timestamp(node_infected,node_infected) = t;
                    C.Information.distance(node_infected,node_infected) = 0;

                    if DEBUG, fprintf('>>> Yes!\n'); end
                    S.Debug.numGenerate = S.Debug.numGenerate+1;
                else
                    if DEBUG, fprintf('>>> No!\n'); end
                    S.Debug.numNoGenerate = S.Debug.numNoGenerate+1;
                end
            end

        end


        %
        % Propagate awareness through information network
        %
        for node_about = 1:P.Topology.numNodes

            % Is there even some information to propagate?
            % Does this node have information about itself?
            if (S.Information.timestamp(node_about,node_about) == 0)
                continue
            end

            if DEBUG, fprintf('>> Propagating about %d\n', node_about); end

            for node_source = 1:P.Topology.numNodes

                % Does this node have information about the other?
                if (S.Information.timestamp(node_source,node_about) == 0)
                    continue
                end

                if DEBUG, fprintf('>>> From %d\n', node_source); end

                neighbors = find(S.Network.info(node_source,:));
                distance = S.Information.distance(node_source,node_about)+1;

                for node_sink = neighbors

                    % Did information already reach this node?
                    % @todo Take min distance in case of collision
                    if (S.Information.timestamp(node_sink,node_about) ~= 0)
                        continue
                    end

                    if DEBUG, fprintf('>>>> To %d?\n', node_sink); end
                    if (rand <= P.Information.probPropagate)
                        C.Information.timestamp(node_sink,node_about) = t;
                        C.Information.distance(node_sink,node_about) = distance;

                        if DEBUG, fprintf('>>>>> Yes!\n'); end
                        S.Debug.numPropagate = S.Debug.numPropagate+1;
                    else
                        if DEBUG, fprintf('>>>>> No!\n'); end
                        S.Debug.numNoPropagate = S.Debug.numNoPropagate+1;
                    end

                end

            end

        end


        if DEBUG, fprintf('> Timestep T = %d\n', t); end


        % Iterate through the infected nodes
        for node_infected = find(S.Disease.infected)

            if DEBUG, fprintf('>> Spreading from %d\n', node_infected); end

            % Infected node may infect his susceptible neighbors
            susceptibles = find(C.Disease.susceptible);
            neighbors = find(S.Network.contact(node_infected,:));
            neighbors_susceptible = intersect(neighbors,susceptibles);


            % @todo Introduce Tinder connections as perturbations


            % Iterate through the susceptible neighbors
            for node_susceptible = neighbors_susceptible

                % Probability along this channel
                prob = P.Disease.probInfect;

                % Incorporate info into infection probability
                awareness = awareness_calculate( ...
                    P.Information, S.Information, t, ...
                    node_infected, node_susceptible);

                prob = prob * (1 - awareness);

                if DEBUG, fprintf('>>> Infecting %d?\n', node_susceptible); end

                if (rand <= prob)
                    % Move to the infected compartment - Sorry, bro!
                    C.Disease.infected(node_susceptible)    = 1;
                    C.Disease.susceptible(node_susceptible) = 0;

                    if DEBUG, fprintf('>>>> Yes!\n'); end
                    S.Debug.numInfect = S.Debug.numInfect+1;
                else
                    if DEBUG, fprintf('>>>> No!\n'); end
                    S.Debug.numNoInfect = S.Debug.numNoInfect+1;
                end

            end

            % Infected may recover with certain probability
            if DEBUG, fprintf('>> Recover %d?\n', node_infected); end
            if (rand <= P.Disease.probRecover)
                % Move to the recovered compartment - Good job!
                C.Disease.recovered(node_infected) = 1;
                C.Disease.infected(node_infected)  = 0;

                if DEBUG, fprintf('>>> Yes!\n'); end
                S.Debug.numRecover = S.Debug.numRecover+1;
            else
                if DEBUG, fprintf('>>> No!\n'); end
                S.Debug.numNoRecover = S.Debug.numNoRecover+1;
            end


        end


        % Apply working copies as updated state
        S.Disease.susceptible   = C.Disease.susceptible;
        S.Disease.infected      = C.Disease.infected;
        S.Disease.recovered     = C.Disease.recovered;
        S.Information.timestamp = C.Information.timestamp;
        S.Information.distance  = C.Information.distance;


        % @todo When are most nodes infected and how many?

        S.Metric.numInfected(sim,t)  = size(find(S.Disease.infected),2);
        S.Metric.numRecovered(sim,t) = size(find(S.Disease.recovered),2);

    end


end


hold on
plot(mean(S.Metric.numInfected,1))
plot(mean(S.Metric.numRecovered,1))
