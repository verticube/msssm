function[] = append_graph(run, P, ks , sirs )
t_max = P.Simulation.numSteps;
id_max = P.Topology.numNodes;

nodes_start = {'    <nodes>'};
node_open = sprintf('      <node id="%d">', id);
at_open = {'        <attvalues>'};
node_ks = sprintf('\n          <attvalue for="knowledge" value="%4.3f" start="%d"></attvalue>', ...
    [ks(id,:);(1:t_max)] );
node_sir_states = sprintf('\n          <attvalue for="state" value="%d" start="%d"></attvalue>', ...
    [sirs(id,:);(1:t_max)] );
at_close = {'        </attvalues>'};
node_close = {'      </node>'};
nodes_end = {'    </nodes>'};
%todo edgees
graph_end = {'  </graph>'};
gexf_end = {'</gexf>'};

fid = fopen(sprintf('Gephi/dynamic_graph_run%d.gexf',run), 'a');
fprintf(fid,'%s\n',nodes_start);
    for id = 1:id_max
        fprintf(fid,'%s\n',node_open);
        fprintf(fid,'%s\n',at_open);
        fprintf(fid,node_ks);
        fprintf(fid,node_sir_states);
        fprintf(fid,'%s\n',at_close);
        fprintf(fid,'%s\n',node_close);
    end
fprintf(fid,'%s\n',nodes_end);
%todo edges
fprintf(fid,'%s\n',graph_end);
fprintf(fid,'%s\n',gexf_end);
fclose(fid);

end 