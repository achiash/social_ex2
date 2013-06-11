function [  ] = infect (G, psi, pir, prs )
% runs infection algorithm described in ex2

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

% STEP 2 - remove infected nodes with probability pir 
rem = (rand(len, 1) <= pir);
I(rem) = 0;
R(~rem) = 1;
%{
for i = find(I)    
    if(rem[i])
        R(i)=1;
        I(i)=0;
        newRemoved = newRemoved+1;        
    end;
end;
%}

% STEP 3 - change removed nodes to susceptible with probability prs
rem = (rand(len, 1) <= pir);
R(rem) = 0;

end

