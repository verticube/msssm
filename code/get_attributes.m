function [sum_knowledge, sir_state] = get_attributes( S, t )

sum_knowledge = zeros(S.Topology.numNodes,1);

%
% Neighborhood of the susceptible nodes
%
for node = 1:S.Topology.numNodes

    distances = S.Information.distances(node,:);
    coefficients = exp(-S.Information.coeffDistance * distances);

    deltas = t - S.Information.timestamps(node,:);
    awarenesses = S.Information.awarenessStart ...
                  - S.Information.awarenessSlope * deltas;

    awarenesses = min(1,max(0,awarenesses .* coefficients));

    sum_knowledge(node) = sum_knowledge(node) + sum(awarenesses);

end
%knowledge
sum_knowledge = min(1,max(0,sum_knowledge));

%SIR state
sir_state = zeros(S.Topology.numNodes,1);
sir_state(1,1) = 2;

for node = 2:S.Topology.numNodes
    if (S.Disease.susceptible(node) > 0)
        sir_state(node) = 1;
    end
    if (S.Disease.infected(node) > 0)
        sir_state(node) = 2;
    end
    if (S.Disease.recovered(node) > 0)
        sir_state(node) = 3;
    end
end
    

% ID; knowledge; SIR
%ID = [1:S.Topology.numNodes];
%attributes = [ ID' values sir_state];

%Write attributes of t in .csv
%your_text = {'Id;knowledge;state'};
%fid = fopen('attributes.csv', 'w');
%fprintf(fid,'%s\n',your_text{:});
%fclose(fid);
%dlmwrite('attributes.csv',attributes,'-append','delimiter',';');

end
