function [ network ] = contact_network( num_nodes )

network = zeros(num_nodes,num_nodes);

%density = 0.2;
%for i = 1:num_nodes
%  for j = i:num_nodes
%      if (rand <= density)
%          network(i,j) = 1;
%          network(j,i) = 1;
%      end
%  end
%end

% Generate uniform grid network
num_per_axis = ceil(sqrt(num_nodes));
for i = 1:num_nodes
    if (rem(i-1,num_per_axis) > 0)
        network(i,i-1) = 1;
        network(i-1,i) = 1;
    end
    if (rem(i-1,num_per_axis) < num_per_axis-1)
        network(i,i+1) = 1;
        network(i+1,i) = 1;
    end
    if (i-num_per_axis >= 1)
        network(i,i-num_per_axis) = 1;
        network(i-num_per_axis,i) = 1;
    end
    if (i+num_per_axis <= num_nodes)
        network(i,i+num_per_axis) = 1;
        network(i+num_per_axis,i) = 1;
    end
end

end
