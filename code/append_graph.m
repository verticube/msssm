function[] = append_graph(run, P, ks , sirs, new_edges )
t_max = P.Simulation.numSteps;
id_max = P.Topology.numNodes;

nodes_start = '    <nodes>';
%node_open(id) = sprintf('      <node id="%d">', id);
at_open = '        <attvalues>';
%node_ks = sprintf('\n          <attvalue for="knowledge" value="%4.3f" start="%d"></attvalue>', ...
%    [ks(id,:);(1:t_max)] );
%node_sir_states = sprintf('\n          <attvalue for="state" value="%d" start="%d"></attvalue>', ...
%    [sirs(id,:);(1:t_max)] );
at_close = '        </attvalues>';
node_close = '      </node>';
nodes_end = '    </nodes>';
%todo edgees --------------
edges_start = '    <edges>';
%edge_open
%edge_at
edge_close = '      </edge>';
edges_end = '    </edges>';
graph_end = '  </graph>';
gexf_end = '</gexf>';


%nodes--------
fid = fopen(sprintf('Gephi/dynamic_graph_run%d.gexf',run), 'a');
fprintf(fid,'%s\n',nodes_start);
    for id = 1:id_max
        node_open = sprintf('      <node id="%d">', id);
        fprintf(fid,'%s\n',node_open );
        fprintf(fid,'%s\n',at_open );
            for i = (find(ks(id,:),1,'first'):t_max ) %
                node_ks = sprintf('          <attvalue for="knowledge" value="%4.3f" start="%d"></attvalue>\n', ...
                    [ks(id,i);i] );
                fprintf(fid,node_ks);
            end
            %fprintf(fid,'          <attvalue for="knowledge" value="0.0" start="%d"></attvalue>\n', max(i)+1);
            for j = [find((sirs(id,:) == 1), 1, 'first'),find((sirs(id,:) == 2), 1, 'first'),find((sirs(id,:) == 3), 1, 'first') ]
                node_sir_states = sprintf('          <attvalue for="state" value="%d" start="%d"></attvalue>\n', ...
                    [sirs(id,j);j] );
                fprintf(fid,node_sir_states);
            end
        fprintf(fid,'%s\n',at_close);
        fprintf(fid,'%s\n',node_close);
    end
fprintf(fid,'%s\n',nodes_end);
fclose(fid);
%edges -----------------
fid = fopen(sprintf('Gephi/dynamic_graph_run%d.gexf',run), 'a');
fprintf(fid,'%s\n',edges_start);
    for edge_id = 1:max(size(new_edges(:,1)))
        edge_open = sprintf('      <edge id="%d" source="%d" target="%d" start="%d" end="%d">\n',...
            new_edges(edge_id,:), new_edges(edge_id,4)+1 );
        fprintf(fid, edge_open);
        fprintf(fid,'%s\n',at_open);
        edge_at = sprintf('          <attvalue for="weight" value="1.0" start="%d" end="%d"></attvalue>\n',...
            new_edges(edge_id,4), new_edges(edge_id,4)+1 );
        fprintf(fid, edge_at);
        fprintf(fid,'%s\n',at_close);
        fprintf(fid,'%s\n',edge_close);
    end
fprintf(fid,'%s\n',edges_end);
%end of file-----------------
fprintf(fid,'%s\n',graph_end);
fprintf(fid,'%s\n',gexf_end);
fclose(fid);

end 