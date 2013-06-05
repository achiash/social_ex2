function [ G ] = generateUA( n,d )
%Generates Uniform Attachment network with n nodes as described in section
%1.2

% Create cell array to keep the graph 
G = cell(n, 1);

for i=1:n
    %uniformly select d new neighbors
    neighbors = randperm(n,d);
    %make sure there are no duplications or self loops
    while (sum(intersect(G{i},neighbors))>0 | any(i==neighbors))
        neighbors = randperm(n,d); 
    end
    G{i} = [G{i} neighbors];
    %add other direction edges
    for j=1:size(neighbors,2)
       current = neighbors(j);
       if (~any(i==G{current}))
           G{current} = [G{current} i];
       end
    end
end


end

