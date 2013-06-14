function [  ] = Q33 ()
% runs Q3.1 algorithm described in ex2
psi=0.05;
pir =0.1;
prs =0.002;

iters= 1;
n = 300;

for run = 1:iters
    
    G=generateSWN(n, 0);
    
    len = size(G, 1);
    
    % Create 3 vectors
    % Infected nodes
    I = zeros(len, 1);
    % Removed nodes
    R = zeros(len, 1);
    % Susceptible nodes
    S = zeros(len, 1);
    
    % Infect a random node
    firstInfected = randi(len);
    I(firstInfected) = 1;
    rounds=0;

    RES = [];
    while (rounds <= 10000 || sum(I)>0)
        rounds = rounds+1
        % STEP 1 - infect all neigbours of the infected nodes with probabability
        % psi
        tmpI = I;
        newInfected = 0;
        % go over all uninfected nodes
        for i = find(tmpI == 0)'
            % skipped removed nodes
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
        
        % Count max infected distance
        tmax = 0;
        I
        for pt = find(R == 1)'
            
            m1 = mod(pt, n);
            m2 = mod(firstInfected, n);
            if(m1 ==0)
                m1 = n;
            end;
            if(m2 ==0)
                m2 = n;
            end;
                
            cd = abs(m1 - m2)
            rd = abs( round(pt/(n+1)) - round(firstInfected/(n+1)))
            
            dist = rd + cd 
            if (dist > tmax)
                tmax = dist;
            end;
        end;
        
        % STEP 2 - remove infected nodes with probability pir
        rem = (rand(len, 1) <= pir);
        rem = logical(rem.*I);
        I(rem) = 0;
        R(rem) = 1;
        
        % STEP 3 - change removed nodes to susceptible with probability prs
        rem = (rand(len, 1) <= prs);
        R(logical(rem)) = 0;        
        
        RES = [RES tmax];
        
        if(rounds>5)
            break;
        end;
        
    end; %while
    

end; % iterations

% plot the results
RES
plot (RES);
title('Euclidian distance from infection origin');
xlabel('Round number');
ylabel('Euclidian distance');
legend('Euclidian distance');



end

