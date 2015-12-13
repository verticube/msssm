function [ C ] = info_propagate( DEBUG, S, C, t )
%INFO_PROPAGATE Propagates information through network.


%
% Iterate over nodes with self-information:
%
for about = find(diag(S.Information.timestamps) ~= 0)'


    if DEBUG, fprintf('>> Propagating about %d\n', about); end


    % Nodes with information about infected
    has_info = S.Information.timestamps(:,about) ~= 0;
    % Nodes with information below cutoff distance
    below_cutoff = S.Information.distances(:,about) ...
                   < S.Information.cutoffDistance;

    %
    % Iterate over nodes with information:
    %
    for source = find(has_info & below_cutoff)'


        if DEBUG, fprintf('>>> From %d\n', source); end


        %
        % Find neighbors to receive new information:
        %

        % Nodes without information about infected
        subjects = S.Information.timestamps(:,about) == 0;
        % Intersect with neighbors of current source
        subjects = S.Network.contact(:,source) & subjects;


        %
        % Apply propagation probability:
        %

        rands           = ones(length(     subjects ),1);
        rands(subjects) = rand(length(find(subjects)),1);
        probs           = S.Information.probPropagate;

        subjects = (rands <= probs) & subjects;


        if DEBUG, fprintf('>>>> To %d\n', find(subjects)); end


        %
        % Propagate new information to receivers:
        %

        d = S.Information.distances(source,about);

        C.Information.timestamps(subjects,about) = t;
        C.Information.distances (subjects,about) = d + 1;

        % @todo Use min(distances) in case of collision

    end

end


end
