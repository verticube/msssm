function [ C, M ] = info_generate( DEBUG, S, C, t )
%INFO_GENERATE Generates self-information with probability.


%
% Find infected nodes without self-information:
%

% Nodes without self-information
subjects = diag(S.Information.timestamps) == 0;
% Intersect with the infected nodes
subjects = S.Disease.infected & subjects;


%
% Apply information generation probability:
%

rands           = ones(length(     subjects ),1);
rands(subjects) = rand(length(find(subjects)),1);
probs           = S.Information.probGenerate;

subjects = (rands <= probs) & subjects;


if DEBUG, fprintf('>> Generating about %d\n', find(subjects)); end


%
% Generate information about those nodes:
%

C.Information.timestamps(diag(subjects)) = t;
C.Information.distances (diag(subjects)) = 0;


end
