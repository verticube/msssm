function [ C ] = sir_infect( DEBUG, S, C, t )
%SIR_INFECT Propagates disease through the network.


%
% Iterate through the infected nodes
%
for node_infected = find(S.Disease.infected)'


    if DEBUG, fprintf('>> Spreading from %d\n', node_infected); end


    %
    % Find susceptible neighbors of this node:
    %

    % Neighbors of the current infected node
    subjects = S.Network.contact(:,node_infected);
    % Intersect with susceptible nodes in population
    subjects = S.Disease.susceptible & subjects;


    %
    % Apply contact probability with awarenesses:
    %

    awarenesses = awareness(S,t,subjects,node_infected);

    rands           = ones(length(     subjects ),1);
    rands(subjects) = rand(length(find(subjects)),1);
    probs = S.Disease.probContact .* (1 - awarenesses);

    subjects = (rands <= probs) & subjects;


    if DEBUG, fprintf('>>> Infecting %d\n', find(subjects)); end


    %
    % Reassign to SIR compartments:
    %

    collisions = C.Disease.infected & subjects;

    C.Disease.infected   (subjects) = t;
    C.Disease.susceptible(subjects) = 0;

    C.Disease.infections(node_infected) = ...
      C.Disease.infections(node_infected) + ...
      length(find(subjects)) - length(find(collisions));

end


end
