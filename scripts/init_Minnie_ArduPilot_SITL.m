
% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2020-2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% add to path
addPathFtc();
clc_clear;

%% load physical copter parameters
copter = copterLoadParams( 'copter_params_Minnie' );

%% environment parameters
envir = envirLoadParams('params_envir','envir',0);

%% initial conditions (IC)
% initial angular velocity omega_Kb, in rad/s
IC.omega_Kb = [ 0; 0; 0 ];
% initial orientation in quaternions q_bg
IC.q_bg = euler2Quat( [ 0; 0; 0 ] );
% initial velocity V_Kb, in m/s
IC.V_Kb = [ 0; 0; 0 ];
% initial position s_Kg, in m
IC.s_Kg = [ 0; 0; 0 ];
% initial motor angular velocity, in rad/s
IC.omega_mot = [ 1; 1; 1; 1 ] * 843;

%% load ground parameters (grnd)
grnd = groundLoadParams( 'params_ground_default' );

%% reference position lat, lon, alt
% initial latitude, in deg
pos_ref.lat = 37.6117;
% initial longitude, in deg
pos_ref.lon = -122.37822;
% initial altitude, in m
pos_ref.alt = 8;

%% Flight Gear settings for UDP connection
% Flight Gear URL
fg.remoteURL = '127.0.0.1';
% fdm receive port of Flight Gear
fg.remotePort = 5502;

%% ArduPilot SITL parameters
SITL.sample_time = 1/400;

%% Open Simulink model
open_model('QuadcopterSimModel_ArduPilot_SITL')