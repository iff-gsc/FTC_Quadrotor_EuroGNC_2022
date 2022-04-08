init_Minnie_Loiter_FTC;

% increase yaw damping
copter.aero.rate_damp = 1;

%%

width = 12;
height = 7;

%% simulate slow 3rd motor failure

failure_time = 1;
failure_slew_rate = 1000;
failure_time_delay_1 = 2;
failure_time_delay_2 = 2;
name_ending = '_fast';
out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-2','StopTime','15');
plotMotorFailures(out,name_ending,width,height)

%% simulate fast 3rd motor failure

failure_time = 1;
failure_slew_rate = 0.1;
failure_time_delay_1 = 2;
failure_time_delay_2 = 0;
name_ending = '_slow';
out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-2','StopTime','15');
plotMotorFailures(out,name_ending,width,height)

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
    legend('$x_g$','$y_g$','$z_g$','interpreter','latex','location','southeast')
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
    legend('$p$','$q$','$r$','interpreter','latex','location','east')
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
