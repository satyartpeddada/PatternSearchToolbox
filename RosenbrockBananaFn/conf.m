%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Problem Configuration Function for the Rosenbrock Banana Function Problem
%==========================================================================
%
% pc = CONF()
%   pc: Structured Data Containing Problem Configurations

function pc = conf()
    pc.nvar = 2;                % Number of variables
    pc.lb = [-2,0];            % Lower bounds
    pc.ub = [2,6];              % Upper bounds
    pc.fs_g = 0.7;             % Shrink factor for global sample range
    pc.xtrue = [1,1];           % True soltuion in x (for comparison)
    pc.ftrue = 0;               % True solution in f (for comparison)
end