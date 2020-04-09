%% PATTERN SEARCH VISUALIZATION DEMO
%==========================================================================
% A modular code for teaching Pattern Search Algorithm
% Author  : Satya R. T. Peddada (speddad2@illinois.edu), Graduate Student
% Advisor : Dr. James T. Allison
% Department of ISE, University of Illinois at Urbana-Champaign
%==========================================================================
% Main Script 
%==========================================================================
clc; clear; close all;
% Problem to be solved
prob = 'BoothFn';        % PROBLEM DIRECTORY NAME

                            % Use one of following predefined problems:
                            % 1. prob = 'BoothFn';
                                  
                            % 2. prob = 'RosenbrockBananaFn';
                                  
                            % 3. prob = 'McCormickFn';
                                 
                            % 4. prob = 'McCormickDifferentRangeFn';
                                  
                            % 5. prob = 'SphereFn';
                          
                            % 6. prob = 'GoldsteinPriceFn';
                           
                            % 7. prob = 'ScaledGoldsteinPriceFn';
                            
                            % Or you can easily generate your own problem
                            % by creating a directory and put objective and
                            % configuration files: 'obj.m' & 'conf.m'
                            
% Save current (parent) directory and problem (sub) directory paths
currentpath = pwd;
probpath = fullfile(currentpath,prob);

% Objective function
% Get obj-fn handle from the problem path
cd(probpath);                                  % Enter the problem directory
objfn = str2func('obj');                       % Obtain function handle for objective function
conffn = str2func('conf');                     % Obtain function handle for configurations
cd(currentpath);                               % Return to the root directory

% Problem configurations (number of variables, lower & upper bounds)
[n_input, lb, ub] = feval(conffn);             % configuration function 
conf.n_input = n_input;                        % number of design variables (x,y,z etc.)
conf.lb = lb;                                  % lower bound on design variables 
conf.ub = ub;                                  % upper bound on design variables   
conf.objfn = objfn;                            
conf.expandfactor = 3.0;
conf.refinefactor = 0.25;

%% Algorithm Parameters

max_iter = 50;                                 % maximum iterations
length_tolerance = 0.001;                      % pattern length tolerance   
fun_tol= 0.001;                                % objective function value tolerance

% Compass directions poll  (Add p24)
% polls.patternshape = [0,1;1,0;0,-1;-1,0];      % compass directions patternshape - complete poll

% Incomplete Poll example
% polls.patternshape = [0,1;1,0;0,-1;0,0];      % compass directions patternshape - incomplete poll
 
% Triangular pattern shape (Remove p24)
% polls.patternshape = [-sqrt(3)/2,-0.5;0,1;sqrt(3)/2,-0.5];

polls.n = size(polls.patternshape,1);          % number of polls per pattern
polls.f_ = zeros(polls.n,1);                   % number of obj fn polls per pattern 
polls.xcatch = zeros(polls.n,2);               % catching the x that has the minimal objfn value   

current.x = [-15, -20];                        % start/initial point  
current.length = 1;                            % length of poll step  
current.x_eval = zeros(polls.n,2);
new_x_k_list = zeros(2,polls.n,max_iter);

% Objective function evaluation
current.f = feval(objfn,current.x);            % initial objective function value 

%% Pattern search algorithm

x_history = zeros(max_iter, conf.n_input);    % Store design vector x values for every iteration
length_history = zeros(max_iter,1);           % Store pattern lengths for every iteration
f_history = zeros(max_iter, 1);               % Store objfn values for every iteration

% while loop
index_iter = 1;                               % initial loop index  
x_history(1,:) = current.x;                   % storing intial point in history
notcompleted = true; 

% searchenabled = true;

% Pattern Search Algorithm 
while notcompleted
    index_iter = index_iter + 1;
        [current, polls] = ptnsrc_poll(current, polls, conf);
        f_polls = polls.f;
        if  polls.success == 1
            current = ptnsrc_expandmesh(current,conf);
            current = ptnsrc_updatecurrentpoint(polls,current);       
        else
            current = ptnsrc_refinemesh(current,conf);
        end
%   end
    new_x_k_list(:,:,index_iter-1) = current.x_eval';
    x_history(index_iter,:) = reshape(current.x,1,numel(current.x));       % update x_history
    f_history(index_iter,1) = feval(objfn,current.x);                      % update f_history 
    length_history(index_iter,1) = current.length;                         % update pattern length history
    if(index_iter>max_iter)|| (abs(current.f-f_history(end-1))<fun_tol)   % loop termination condition
        notcompleted = false; 
    end
end

% Plot Objective Function History
new_x_history = new_x_k_list(:,:,1:index_iter);
plot(2:length(f_history),f_history(2:end),'-o','MarkerSize',2,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6],'linewidth',2);
hold on
xlabel('Poll number')
ylabel('Objective function value (history)')
title('Objective function history vs. number of polls')
legend('function values')

%% Animation
% Plot objective function contours
n = 30;                  % no of contours/level sets
x = linspace(-25,25,n);
y = linspace(-25,25,n);
[X,Y] = meshgrid(x,y);
Z = zeros(n,n);
for j = 1:n
    for i = 1:n
        Z(i,j) = objfn([X(i,j),Y(i,j)]);
    end
end
figure
conplot = contour(X,Y,Z,30);
colormap autumn(3);
xlabel('$x_1$','Interpreter','latex');
ylabel('$x_2$','Interpreter','latex');
title ('Pattern search animation')
axis equal manual;
hold on
xopt = x_history(index_iter,:)

index_iter

for ix = 1 : index_iter-1
   % Draw current.x
    p1 = plot(x_history(ix,1),x_history(ix,2),...
        'Color','red','LineStyle','-','LineWidth',2,'Marker','.','MarkerSize',35);
    pause(0.1);
      % Draw dashed lines from x_k to new_x_k
    p21 = plot([x_history(ix,1),new_x_history(1,1,ix)],[x_history(ix,2),new_x_history(2,1,ix)],...
        'Color',[0.75,0.75,0.75],'LineStyle','--','LineWidth',2);
    p22 = plot([x_history(ix,1),new_x_history(1,2,ix)],[x_history(ix,2),new_x_history(2,2,ix)],...
        'Color',[0.75,0.75,0.75],'LineStyle','--','LineWidth',2);
    p23 = plot([x_history(ix,1),new_x_history(1,3,ix)],[x_history(ix,2),new_x_history(2,3,ix)],...
        'Color',[0.75,0.75,0.75],'LineStyle','--','LineWidth',2);
    if polls.n == 4
     p24 = plot([x_history(ix,1),new_x_history(1,4,ix)],[x_history(ix,2),new_x_history(2,4,ix)],...
        'Color',[0.75,0.75,0.75],'LineStyle','--','LineWidth',2);
    end
    pause(0.2);
      %  Draw new_x_k (four poles)
    p3 = plot([new_x_history(1,:,ix)],[new_x_history(2,:,ix)],...
        'Color','red','LineStyle','none','LineWidth',2,'Marker','o','MarkerSize',4);
    pause(0.2);
    %    Change unused new_x_k to grey
    p4 = plot([new_x_history(1,:,ix)],[new_x_history(2,:,ix)],...
        'Color',[0.75,0.75,0.75],'LineStyle','none','LineWidth',2,'Marker','o','MarkerSize',4);    
       % Draw x_(k+1) and line from x_k to x_(k+1)
    p5 = plot([x_history(ix,1),x_history(ix+1,1)],[x_history(ix,2),x_history(ix+1,2)],...
        'Color','black','LineStyle','-','LineWidth',3,'Marker','.','MarkerSize',5);
    pause(0.2);
% 
end
    popt = plot(x_history(index_iter,1),x_history(index_iter,2),...
      'Color','green','LineStyle','-','LineWidth',2,'Marker','.','MarkerSize',35);
   % legend('objfn', 'xhistory','mesh lines')
    

   
   
   %% Options to explore
% Patternshapes - triangular, polygonal, basis functions, etc. 
% Tolerances : Mesh tolerance, constraint (or bind) tolerance, etc.
% Mesh expansion and refinement
% Adding constriants
% Trying other objective functions
% Comparing with other methods (gradient descent, ga, etc.)
% Search methods
% if searchenabled
%         searchresult = ptnsrc_search();
%         if searchresult.success
%             ptnsrc_updatecurrentpoint();
%         else
%             pollresult = ptnsrc_poll();
%             if pollresult.success
%                 ptnsrc_expandmesh();
%                 ptnsrc_updatecurrentpoint();
%             else
%                 ptnsrc_refinemesh();
%             end
%         end
%     else
%end
