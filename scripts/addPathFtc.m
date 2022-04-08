function [] = addPathFtc()

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

this_file_path = fileparts(mfilename('fullpath'));
cd(this_file_path);
addpath(genpath(this_file_path));
cd ..

% add folders to path
addpath(genpath('libraries'));
addpath(genpath('models'));
addpath(genpath('functions'));

cd(this_file_path);

end