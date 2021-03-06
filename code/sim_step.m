function [ S ] = sim_step( DEBUG, S, t )
%SIM_STEP Performs one timestep of simulation for t > 1.


%
% Propagate awareness through information network:
%
S = info_propagate(DEBUG,S,S,t); % Note: C = S


C = S; % Create working copy (new state)


%
% Introduce random contacts, e.g. Tinder dates:
%
% Note: C still holds unperturbed contact network!
%
S = network_perturb(DEBUG,S);


%
% Propagate disease through contact network:
%
C = sir_infect(DEBUG,S,C,t);


%
% Generate self-information where necessary:
%
C = info_generate(DEBUG,C,C,t); % Note: C = S


%
% Recover previously infected where necessary:
%
C = sir_recover(DEBUG,S,C,t);


S = C; % Apply working copy as new state


end
