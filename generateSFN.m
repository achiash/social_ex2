function G = generateSFN(n , d)
%Generate a scale free network with n nodes and d new edges per each new
%node as described in section 1.1

if (n<2*d + 1)
    display ('n<2d+1 ... exiting');
    return;
end;

% Create cell array to keep the graph 
G = cell(n, 1);

% Maintain another array to track added nodes degree (used in generating
% new node edges)
da = zeros(n*d, 1);
% Counter for currently filled cells in da array
da_size = 0;


% generate a clique of first 2d+1 nodes
for i = 1 : (2*d + 1)  
    tmp = [];
    for j = 1 : (2*d + 1)  
        if (i ~= j)            
            tmp = [tmp j];
            % add to da array
            da(da_size+1) = j;            
            da_size = da_size+1;            
        end;
    end;
    % add to graph 
    G{i, 1} = tmp;
    
end;

% add n- (2d+1) nodes
for v = 2*d+2 : n
    new_edges = 0;
    while (new_edges < d)
        r = randi(da_size, 1);
        e = da(r);
        %G{v, 1}
        %e
        if ( sum(find(G{e, 1} == v)) == 0) 
            % add edge
            G{v, 1} = [G{v, 1} e];
            G{e, 1} = [G{e, 1} v];
            % update da
            da(da_size+1) = v;
            da(da_size+2) = e;
            da_size = da_size + 2;     
            
            % increment new edges count
            new_edges = new_edges + 1;
        end;
    end;
end;

end

