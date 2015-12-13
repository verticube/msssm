function [ S ] = network_perturb( DEBUG, S )
%NETWORK_PERTURB Adds random contacts to network.


%
% Select the nodes going on a date:
%

rands = rand(S.Topology.numNodes,1);
probs = S.Perturbation.probRandContact;

subjects = rands <= probs;

nodes = find(subjects);


%
% Shuffle and add pairs to contact network:
%

nodes_dating = nodes(randperm(length(nodes)));

for i = 1:2:length(nodes)-1 % Skip remainder

    one = nodes_dating(i);
    two = nodes_dating(i+1);


    if DEBUG, fprintf('>> %d and %d dating\n', one, two); end


    S.Network.contact(one,two) = 1;
    S.Network.contact(two,one) = 1;

end


end
