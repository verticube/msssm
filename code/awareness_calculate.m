function [ awareness ] = awareness_calculate( params, info, t, infected, susceptible )

num_nodes = size(info.timestamp,1);

awareness = 0;

% awareness of infected
delta = t-info.timestamp(infected,infected);
if (delta > params.numStepsZero && ...
    delta-params.numStepsZero < params.numStepsNonZero)
    awareness = awareness + params.nonZeroAwareness;
end

% neighborhood of susceptibles
for node = 1:num_nodes

    if (node == susceptible)
        continue
    end

    d = info.distance(susceptible,node);
    delta = t-info.timestamp(susceptible,node);

    % @todo cutoff d?

    if (delta > params.numStepsZero && ...
        delta-params.numStepsZero < params.numStepsNonZero)
        awareness = awareness + params.nonZeroAwareness * ...
                                exp(-params.coeffDistance * d);
    end

end

awareness = min(1,awareness);

end
