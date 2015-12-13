function [ C ] = sir_recover( DEBUG, S, C, t )
%SIR_RECOVER Recovers infected nodes with probability.


%
% Find infected nodes in population:
%

subjects = S.Disease.infected > 0;


%
% Apply recovery probability to those nodes:
%

rands           = ones(length(     subjects ),1);
rands(subjects) = rand(length(find(subjects)),1);
probs           = S.Disease.probRecover;

subjects = (rands <= probs) & subjects;


if DEBUG, fprintf('>> Recovering %d\n', find(subjects)); end


%
% Reassign to SIR compartment:
%

C.Disease.recovered(subjects) = t;
C.Disease.infected (subjects) = 0;


end
