function [ G ] = generateSWN( n,Prewire )
%Generates a small world network with n*n nodes and Prewire probability of
%rewiring edges as described in section 1.3

% Create cell array to keep the graph 
G = cell(n*n, 1);

%Create neighbors edges
for i=1:(n*n)
    if (i>n)
        %up
        G{i, 1} = [G{i, 1} i-n];
        %up left
        if (rem(i,n) >1 | rem(i,n)==0)
            G{i, 1} = [G{i, 1} i-n-1];
        end
        %up right
        if (rem(i,n) ~= 0)
            G{i, 1} = [G{i, 1} i-n+1];
        end
    end
    %left
    if (rem(i,n) >1 | rem(i,n)==0)
        G{i, 1} = [G{i, 1} i-1];
    end
    %right
    if (rem(i,n) ~= 0)
        G{i, 1} = [G{i, 1} i+1];
    end
    if (i <= n*(n-1))
        %down
        G{i, 1} = [G{i, 1} i+n];
        %down left
        if (rem(i,n) >1 | rem(i,n)==0)
            G{i, 1} = [G{i, 1} i+n-1];
        end
        %down right
        if (rem(i,n) ~= 0)
            G{i, 1} = [G{i, 1} i+n+1];
        end
    end
end

%rewire edges
for i=1:(n*n)
    s = size(G{i},2);
    for j=1:s
        p = rand(1);
        if (p < Prewire)
            current = G{i}(s);
            new = current;
            while (new == current)
               new = randi(n*n);
               G{i}(s) = new;
            end
        end;
    end
end



end

