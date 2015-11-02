%%%
%%% External Libraries
%%%

addpath('graphviz')

%%%
%%% Simulation Parameters
%%%

num_nodes = 49;       % Number of individuals in network

prob_infection = 0.25; % Probability per timestep of infection to spread
                       % along edge between infected and susceptible
prob_recovery  = 0.25; % Probability per timestep of infected to recover

num_steps = 40;        % Number of timesteps for simulation

pause_plot = 0.5;      % Pause X seconds between each timestep

plot_marker_size = 2000/num_nodes;

%%%
%%% Data Structures
%%%

%
% Contact network along which the disease spreads
%
network = contact_network(num_nodes);

[coords_x, coords_y] = make_layout(network);
coordinates = [coords_x' coords_y'];

%
% States 1: SIR compartments (epidemiology)
%
% X(i) == 1 <-> Individual #i belongs to compartment X
% X(i) == 0 <-> Otherwise
%
% Integrity:
% - One individual must belong to exactly one compartment.
%   @todo Enforce this integrity condition e.g. via function?
%
susceptible =  ones(1,num_nodes); % may be infected (sink)
infected    = zeros(1,num_nodes); % may infect susceptibles (source)
recovered   = zeros(1,num_nodes); % do not contribute to spreading

%%%
%%% Simulation
%%%

% Infect Individual #1
susceptible(1) = 0;
   infected(1) = 1;
   
frames = []

%
% Simulate for num_steps timesteps
%
for t = 1:num_steps
    
    fprintf('> timestep T = %d\n', t)
    
    % Create working copies of State
    susceptible_copy = susceptible;
    infected_copy = infected;
    recovered_copy = recovered;
    
    % Identify nodes in the compartments
    
    nodes_infected    = find(infected);
    nodes_susceptible = find(susceptible);
    
    % Iterate through the infected nodes
    for node_infected = nodes_infected
        
        fprintf('>> spreading from %d\n', node_infected)
        
        % Infected node may infect his susceptible neighbors
        
        neighbors = find(network(node_infected,:));
        neighbors_susceptible = intersect(neighbors,nodes_susceptible);
        
        % @todo Introduce Tinder connections as perturbations
        
        % Iterate through the susceptible neighbors
        for node_susceptible = neighbors_susceptible
            
            % Probability along this path
            prob = prob_infection;
            
            % @todo Consider information into prob_infection
            
            if (rand <= prob)
                
                fprintf('>>> infecting %d\n', node_susceptible)
                
                % Move to Infected compartment - Sorry, bro!
                susceptible_copy(node_susceptible) = 0;
                   infected_copy(node_susceptible) = 1;
                   
                % @todo Generate information about new infection
                
            end
            
        end
        
        % Infected may recover with certain probability
        if (rand <= prob_recovery)
            
            fprintf('>> recovering %d\n', node_infected)

            % Move to Recovered compartment - Congrats!
            infected_copy(node_infected) = 0;
            recovered_copy(node_infected) = 1;
            
        end
        
    end
    
    % @todo Implement information spread
    
    % Apply working copies as updated State
    
    susceptible = susceptible_copy;
    infected = infected_copy;
    recovered = recovered_copy;

    % Print assignment of nodes to compartments
    disp([susceptible; infected; recovered].')
    
    % Plot current state of the network
    hold on
    axis off
    gplot(network, coordinates, 'k');
    for node = find(susceptible)
        plot(coordinates(node,1),coordinates(node,2),'.g','MarkerSize',plot_marker_size)
    end
    for node = find(infected)
        plot(coordinates(node,1),coordinates(node,2),'.r','MarkerSize',plot_marker_size)
    end
    for node = find(recovered)
        plot(coordinates(node,1),coordinates(node,2),'.k','MarkerSize',plot_marker_size/2)
    end
    frames = [frames; getframe];
    clf
    
end

axis off
movie(frames, 1, 1/pause_plot)
movie2avi(frames,sprintf('../videos/movie-%s.avi',datestr(now,30)),'fps',1/pause_plot)
