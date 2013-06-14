function [  ] = Q32b ()
% runs Q3.2 algorithm described in ex2
psi=0.2;
pir =0.2;
prs =0;

iters= 2;

% result vector
RES = [];
COST = [];
for seed = 100:100:200
    
    for run = 1:iters
        G=generateSFN(10000, 3);
        
        len = size(G, 1);
        
        % Choose the L list of 100 random nodes
        L = randperm(len, 100);
        
        % Choose L1 list - of 100 neighbours od L
        L1 = zeros(100, 1);
        for i=1:100
            L1(i) = G{L(i)}(randi (size(G{L(i)}, 2)));
        end;
        
        % Create 3 vectors
        % Infected nodes
        I = zeros(len, 1);
        % Removed nodes
        R = zeros(len, 1);
        % Susceptible nodes
        S = zeros(len, 1);
        
        % select random seed vacinated nodes
        %R(randperm(len, seed))  = 1;
        
        % select seed highest degree nodes
        cellsz = cellfun(@length,G,'uni',false);
        a = cell2mat(cellsz');
        [sortedValues,sortIndex] = sort(a(:),'descend');
        maxIndex = sortIndex(1:seed);
        R(maxIndex) = 1;
               
        % Infect a random node
        firstInfected = randi(len);
        I(firstInfected) = 1;
        rounds=0;
        Ltime = 0;
        L1time=0;
        while (sum(I)>0)
            rounds = rounds+1
            % STEP 1 - infect all neigbours of the infected nodes with probabability
            % psi
            tmpI = I;
            newInfected = 0;
            % go over all uninfected nodes
            for i = find(tmpI == 0)'
                % skipped removed nodes
                % also skipp immune nodes (vaccinated)
                if(R(i) == 1)
                    continue;
                end;
                % recreate matrix column from neighbour list
                tmp = zeros(1, len);
                tmp(G{i})=1;
                neibourCount = tmp*tmpI;
                % calculate probaility for being infected depending on infected
                % neigbours count
                if(sum(rand(neibourCount, 1) <= psi) > 0)
                    % infect node
                    I(i) = 1;
                    newInfected = newInfected+1;
                end; %if
            end; % for
            
            % STEP 2 - remove infected nodes with probability pir
            rem = (rand(len, 1) <= pir);
            rem = logical(rem.*I);
            I(rem) = 0;
            R(rem) = 1;
            
            % STEP 3 - change removed nodes to susceptible with probability prs
            rem = (rand(len, 1) <= prs);
            R(logical(rem)) = 0;
        end; %while
        
        RES = [RES  10*(sum(R)-seed)+seed*1]
        
    end; % 100 iterations
    COST = [COST mean(RES)]
    
    % plot the results
    
    %{
M = [tmpL;tmpL1]'

plot (M);
title('Rounds to infect 30 nodes L vs L1');
xlabel('Round number');
ylabel('Time to finish (in iterations)');
legend('L', 'L1');
    %}
    
end;

end

