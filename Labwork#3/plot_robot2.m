
%% PLOT do Rob� com velocidades

function plot_robot2(robot, k, V, qVelocidades, q_controlo, pos)

    % Plot segundo o Controlador
    figure('units','normalized','outerposition',[0 0 1 1]);
    % Prespectiva de lado do Rob�
    subplot(2,3,1);
    robot.plot(q_controlo(1,:), 'workspace', [-10 60 -10 60 -10 60], 'reach', ... % [-40 60 -10 100 -10 70]
        1, 'scale', 8, 'zoom', 0.25); % 'view', 'top', 'trail', 'b.');
    % Prespectiva de topo do Rob�
    subplot(2,3,4);
    robot.plot(q_controlo(1,:), 'workspace', [-10 60 -10 60 -10 60], 'reach', ...
        1, 'scale', 8, 'zoom', 0.25, 'view', 'top'); % 'trail', 'b.');

    % Anima��o do rob�
    X = linspace(1, k-1, k);
      
    for i=1:k-1
        tic % Start a stopwatch timer
        
        robot.animate(q_controlo(i,:));

        % Plot das Velocidades Cartesianas
        subplot(2,3,2);
        v = plot( X(1:i), V(1:i,1)', '.',... % '-'
                  X(1:i), V(1:i,2)', '.',... % 'o'
                  X(1:i), V(1:i,3)', '.');
        title('Velocidades Cartesianas');
        xlabel('k')
        ylabel('Velocidade Cartesiana (m/s)')
        xlim([0 k-1])
        ylim([-5 100])
        grid on

        % Plot das Velocidades das Juntas
        subplot(2,3,3);
        wth = plot( X(1:i), qVelocidades(1,1:i), '.',...
                    X(1:i), qVelocidades(2,1:i), '.',...
                    X(1:i), qVelocidades(3,1:i), '.');
        title('Velocidades das Juntas');
        xlabel('k')
        ylabel('Velocidade das Juntas (rad/s e cm/s)')
        xlim([0 k-1])
        grid on

        % Plot das Posi��es X Y Z        
        subplot(2,3,5);
        pos_ = plot( X(1:i), pos(1:i,1)', '.',...
                     X(1:i), pos(1:i,2)', '.',...
                     X(1:i), pos(1:i,3)', '.');
        title('Posicoes XYZ do gripper');
        xlabel('k')
        ylabel('Posicao (cm)')
        xlim([0 k-1])
        ylim([-5 60])
        grid on
        
        % Plot das Juntas
        subplot(2,3,6);
        th = plot( X(1:i), rad2deg(q_controlo(1:i,1)'), '.',...
                   X(1:i), rad2deg(q_controlo(1:i,2)'), '.',...
                   X(1:i), q_controlo(1:i,3)', '.');
        title('Juntas');
        xlabel('k')
        ylabel('Valores Juntas (rad e cm)')
        xlim([0 k-1])
        grid on

        %drawnow; %pause(0.05);  % this innocent line prevents the Matlab hang
        toc % Read the stopwatch timer

        % Temos que melhorar a perfomance destes plots!
    end
    
    legend(v, 'Vx', 'Vy', 'Vz');
    legend(wth, 'W theta1', 'W theta2', 'V d3');
    legend(pos_, 'X', 'Y', 'Z');
    legend(th, 'Theta1', 'Theta2', ' d3');

end