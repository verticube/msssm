function [ values ] = awareness( S, t, susceptibles, infected )


values = zeros(length(susceptibles),1);


%
% Self-awareness of the infected node
%

delta = t - S.Information.timestamps(infected,infected);

awareness_infected = S.Information.awarenessStart ...
                     - S.Information.awarenessSlope * delta;

values = values + min(1,max(0,awareness_infected));


%
% Neighborhood of the susceptible nodes
%
for susceptible = find(susceptibles)'

    distances = S.Information.distances(susceptible,:);
    coefficients = exp(-S.Information.coeffDistance * distances);

    deltas = t - S.Information.timestamps(susceptible,:);
    awarenesses = S.Information.awarenessStart ...
                  - S.Information.awarenessSlope * deltas;

    awarenesses = min(1,max(0,awarenesses .* coefficients));

    values(susceptible) = values(susceptible) + sum(awarenesses);

end


values = min(1,max(0,values));


end
