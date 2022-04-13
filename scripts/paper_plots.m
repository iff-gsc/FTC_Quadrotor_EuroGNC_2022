% run multiple simulations to create figures for the paper

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

init_Minnie_Loiter_FTC;

% disable stick inputs
block = find_system('QuadcopterSimModel_Loiter_FTC','SearchDepth',1,'Name','Manual Switch');
set_param(block{1}, 'sw', '0');

% moderate yaw damping
copter.aero.rate_damp = 0.8;

%%

width = 12;
height = 7;

%% simulate fast 3rd motor failure

failure_time_mot_1      = 1000;
failure_slew_rate_mot_1 = 0;
failure_time_mot_2      = 2;
failure_slew_rate_mot_2 = 1000;
failure_time_mot_3      = 3;
failure_slew_rate_mot_3 = 1000;
failure_time_mot_4      = 2;
failure_slew_rate_mot_4 = 1000;

name_ending = '_fast';
out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-2','StopTime','15');
plotMotorFailures(out,name_ending,width,height)

%% simulate slow 3rd motor failure

failure_time_mot_1      = 1000;
failure_slew_rate_mot_1 = 0;
failure_time_mot_2      = 2;
failure_slew_rate_mot_2 = 1000;
failure_time_mot_3      = 2;
failure_slew_rate_mot_3 = 0.2;
failure_time_mot_4      = 2;
failure_slew_rate_mot_4 = 1000;
name_ending = '_slow';
out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-2','StopTime','15');
plotMotorFailures(out,name_ending,width,height)

%% fly square with only two rotors

% enable stick inputs
block = find_system(gcb,'SearchDepth',0,'Name','Manual Switch');
set_param(block{1}, 'sw', '1');

% high yaw damping (like in cardboard flight test)
copter.aero.rate_damp = 1.2;

failure_time_mot_1      = 1000;
failure_slew_rate_mot_1 = 0;
failure_time_mot_2      = 1;
failure_slew_rate_mot_2 = 1000;
failure_time_mot_3      = 1000;
failure_slew_rate_mot_3 = 0;
failure_time_mot_4      = 1;
failure_slew_rate_mot_4 = 1000;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','0','StopTime','30');

figure
hold on
idx = 1:length(out.s_g.Time);
idx = idx(1:12:end);
idxr = 1:length(out.s_g_ref.Time);
idxr = idxr(1:4:end);
plot( squeeze(out.s_g_ref.Data(2,:,idxr)), squeeze(out.s_g_ref.Data(1,:,idxr)) )
plot( squeeze(out.s_g.Data(2,:,idx)), squeeze(out.s_g.Data(1,:,idx)) )
axis equal
grid on
xlabel('East position in s','interpreter','latex')
ylabel('North position in m','interpreter','latex')
legend('reference','measured','interpreter','latex','location','best')
set(gca,'TickLabelInterpreter','latex');
plot2Pdf( ['sim_failure_pos_pos'], width,height)


%% plot results

function plotMotorFailures(out,name_ending,width,height)

    idx = find(out.s_g.Time>0)';
    idx2 = find(out.input.Time>0)';
    
    % downsample
    idx = idx(1:12:end);
    idx2 = idx2(1:4:end);
    
    line_width = 1;

    figure
    plot(out.s_g.Time(idx),squeeze(out.s_g.Data(1,:,idx)),'LineWidth',line_width)
    hold on
    plot(out.s_g.Time(idx),squeeze(out.s_g.Data(2,:,idx)),'--','LineWidth',line_width)
    plot(out.s_g.Time(idx),squeeze(out.s_g.Data(3,:,idx)),'LineWidth',line_width)
    grid on
    xlabel('Time in s','interpreter','latex')
    ylabel('Position in m','interpreter','latex')
    legend('$x_g$','$y_g$','$z_g$','interpreter','latex','location','east')
    set(gca,'TickLabelInterpreter','latex');
    plot2Pdf( ['sim_motor_failure_pos',name_ending], width,height)

    figure
    plot(out.omega_Kb.Time(idx),squeeze(out.omega_Kb.Data(1,:,idx)),'LineWidth',line_width)
    hold on
    plot(out.omega_Kb.Time(idx),squeeze(out.omega_Kb.Data(2,:,idx)),'--','LineWidth',line_width)
    plot(out.omega_Kb.Time(idx),squeeze(out.omega_Kb.Data(3,:,idx)),'LineWidth',line_width)
    grid on
    xlabel('Time in s','interpreter','latex')
    ylabel('Angular velocity in rad/s','interpreter','latex')
    legend('$p$','$q$','$r$','interpreter','latex','location','northeast')
    set(gca,'TickLabelInterpreter','latex');
    plot2Pdf( ['sim_motor_failure_rates',name_ending], width,height)

    figure
    plot(out.motor_speed.Time(idx),squeeze(out.motor_speed.Data(idx,1)),'LineWidth',line_width)
    hold on
    plot(out.motor_speed.Time(idx),squeeze(out.motor_speed.Data(idx,2)),'--','LineWidth',line_width)
    plot(out.motor_speed.Time(idx),squeeze(out.motor_speed.Data(idx,3)),'LineWidth',line_width)
    plot(out.motor_speed.Time(idx),squeeze(out.motor_speed.Data(idx,4)),':','LineWidth',line_width)
    grid on
    xlabel('Time in s','interpreter','latex')
    ylabel('Motor speed in rad/s','interpreter','latex')
    legend('$\omega_1$','$\omega_2$','$\omega_3$','$\omega_4$','interpreter','latex','location','southeast')
    set(gca,'TickLabelInterpreter','latex');
    plot2Pdf( ['sim_motor_failure_motor_speed',name_ending], width,height)

    figure
    plot(out.input.Time(idx2),squeeze(out.input.Data(idx2,1)),'LineWidth',line_width)
    hold on
    plot(out.input.Time(idx2),squeeze(out.input.Data(idx2,2)),'--','LineWidth',line_width)
    plot(out.input.Time(idx2),squeeze(out.input.Data(idx2,3)),'LineWidth',line_width)
    plot(out.input.Time(idx2),squeeze(out.input.Data(idx2,4)),':','LineWidth',line_width)
    grid on
    xlabel('Time in s','interpreter','latex')
    ylabel('Dimensionless motor input','interpreter','latex')
    legend('$u_1$','$u_2$','$u_3$','$u_4$','interpreter','latex','location','southeast')
    set(gca,'TickLabelInterpreter','latex');
    plot2Pdf( ['sim_motor_failure_input',name_ending], width,height)
    
end
