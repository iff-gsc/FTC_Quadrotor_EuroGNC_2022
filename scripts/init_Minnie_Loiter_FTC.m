
% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2020-2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% add to path
addPathFtc();
clc_clear;

%% rotor failure parameters
failure_time_mot_1      = 1000;
failure_slew_rate_mot_1 = 0;
failure_time_mot_2      = 2;
failure_slew_rate_mot_2 = 1000;
failure_time_mot_3      = 6;
failure_slew_rate_mot_3 = 0.1;
failure_time_mot_4      = 4;
failure_slew_rate_mot_4 = 1000;

%% control inputs
% fly 5m square after 5s
simin.time                  = [ 0, 5:2.5:(5+2.5*8) ]';
simin.signals.values        = zeros( 4, 10 )';
simin.signals.values(:,1)   = [ 0, 1, 0, 0, 0, -1, 0, 0, 0, 0 ]'*0.365;
simin.signals.values(:,2)   = [ 0, 0, 0, -1, 0, 0, 0, 1, 0, 0 ]'*0.365;
simin.signals.dimensions    = 4;

%% load physical copter parameters
copter = copterLoadParams( 'copter_params_Minnie' );

% increase rotational damping
copter.aero.rate_damp = 1.2;

%% environment parameters
envir = envirLoadParams('params_envir','envir',0);

%% controller parameters
% load parameters
fm_loiter = fmCopterLoiterIndiLoadParams( 'fmCopterLoiterIndi_params_Minnie' );

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
pos_ref.alt = 15;

%% Flight Gear settings for UDP connection
% Flight Gear URL
fg.remoteURL = '127.0.0.1';
% fdm receive port of Flight Gear
fg.remotePort = 5502;

%% Open Simulink model
open_model('QuadcopterSimModel_Loiter_FTC')