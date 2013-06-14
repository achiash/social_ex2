function [ RES ] = Q33 ()
% runs Q3.3 algorithm described in ex2
psi=0.05;
pir =0.1;
prs =0.002;
prewire = 0.3;
iters= 1;
n = 300;
tmax = 0;
done = 0;
while(done==0)
    
    G=generateSWN(n, prewire);
    
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
    while (rounds <= 10000 && sum(I)>0)
        rounds = rounds+1
        sumI = sum(I)
        sumR = sum(R)
        % STEP 1 - infect all neigbours of the infected nodes with probabability
        % psi
        tmpI = I;
        newInfected = [];
        for i = find(tmpI == 1)'
            % skipped removed nodes
            
            % recreate matrix column from neighbour list
            tmp = zeros(1, len);
            tmp(G{i})=1;
            %neibourCount = tmp*tmpI;
            % calculate probaility for being infected depending on infected
            % neigbours count
            for j = find(tmp == 1)
                r = rand();
                if( r<= psi && R(j)==0 )
                    I(j) = 1;
                    newInfected = [newInfected j];
                end;
            end;
            
        end; % for
        
        % Count max infected distance
        
        for pt = newInfected
            
            m1 = mod(pt, n);
            m2 = mod(firstInfected, n);
            if(m1 ==0)
                m1 = n;
            end;
            if(m2 ==0)
                m2 = n;
            end;
            
            cd = abs(m1 - m2);
            rd = abs( round(pt/(n+1)) - round(firstInfected/(n+1)));
            
            dist = sqrt(rd^2 + cd^2);
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
        
        
    end; %while
    if(rounds>=20)
            done =1;
    end;
    
end; % iterations

% plot the results
RES
plot (RES);
title('Euclidian distance from infection origin');
xlabel('Round number');
ylabel('Euclidian distance');
legend('Euclidian distance');



end