clear all
close all
clc

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%                                                                  %%')
disp('%%          [Rob�tica - 07/11/2017 ~ 26/11/2017] LABWORK#3          %%')
disp('%%                                                                  %%')
disp('%%                   Frederico Vaz, n� 2011283029                   %%')
disp('%%                   Paulo Almeida, n� 2010128473                   %%')
disp('%%                                                                  %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ')
disp('*************************** Exerc�cio 3 ******************************')

%% Robot 3-DOF (2 de rota��o e 1 prism�ticos): RPR

syms theta1 d2 theta3 alfa

% Comprimentos dos elos:
L2 = 10;

% Junta Rotacional ou Prismatica:
R = 1; P = 0;
%_________________________________________________________________________________
%          thetai  |  di  |  ai |  alfai | offseti | jointtypei
%_________________________________________________________________________________
PJ_DH = [  theta1      0      0     pi/2     pi/2           R;   % Junta Rotacional
%_________________________________________________________________________________
                0     d2      0    -pi/2        0           P;   % Junta Prism�tica
%_________________________________________________________________________________
           theta3      0      0     pi/2        0           R;   % Junta Rotacional
%_________________________________________________________________________________
                0     L2      0        0        0           R; ]; % Indiferente (N�o aplic�vel)
%_________________________________________________________________________________

% A cinematica directa da base   at� ao Gripper: 
[ oTg, Ti ] = direct_kinematics(PJ_DH);       

oTg = simplify(oTg);
Ti  = simplify(Ti) ;


%% INICIALIZA��O DO ROBOT: CRIAR LINKS


for i = 1 : size(PJ_DH,1)
    
    if PJ_DH(i,6) == R              % Juntas Rotacionais
        
        L(i) = Link('d',eval(PJ_DH(i,2)),...
                    'a', eval(PJ_DH(i,3)),...
                    'alpha', eval(PJ_DH(i,4)),...
                    'offset', eval(PJ_DH(i,5)));
    end
    
    if PJ_DH(i,6) == P              % Junta Prism�tica
        
        L(i) = Link('theta',eval(PJ_DH(i,1)),...
                    'a', eval(PJ_DH(i,3)),...
                    'alpha', eval(PJ_DH(i,4)),...
                    'offset', eval(PJ_DH(i,5)),...
                    'qlim', [25 50]);
        
    end

end

robot = SerialLink(L, 'name', 'Robot Planar RRR');


%% VARI�VEIS GLOBAIS 

% Inicializa��o do vector de juntas na nossa posi��o "home" a come�ar no
% no ponto inicial [ bmin, -30, 35] dado no enuciado 

% POSI��O HOME:
% bTf = [  0  -cos(alfa)  sin(alfa)  40;
%          0   sin(alfa)  cos(alfa)  20; 
%          0   0          0           0;  
%          0   0          0           1  ];

bTf = [  0   0  0  40;
         0   0  0  20; 
         0   0  0   0;  
         0   0  0   1  ];


[ q ] = inverse_kinematics_ex3(bTf);

q = [ q(1:3) 0 ];

% Juntas em symbolic p/ resolver o Jacobiano
q_aux = [ theta1 d2 theta3 ];

% Construir jacobiana 2 partir dos par�metros calculados na cinem�tica inversa
Jac = Jacobian(oTg, Ti, q_aux, PJ_DH(:,6));

% Componentes de velocidade objectivo [ vx vy wz ]
Jac_ = [ Jac(1:2, 1:3); Jac(6,1:3) ];


%% MENU ("main")

% Variaveis MENU
select = 0;
select2 = 0;
STOP = 6;
STOP2 = 3;

while(select ~= STOP)
    
    select = menu('Seleccione a acao a realizar:', 'Cinematica Directa',...
                                                    'Plot do Robo',...
                                                    'alinea 2)',...
                                                    'alinea 3)',...
                                                    'Mover Robot',...
                                                    'Quit');  
                                                
    % Matriz dos parametros de Denavith-Hartenberg: PJ_DH
    if select == 1  
        disp('______________________________________________________________________')
        disp(' ')
        disp('PJ_DH: Matriz dos parametros de Denavith-Hartenberg:')
        disp('______________________________________________________________________')
        disp(' ')
        PJ_DH_ = SerialLink(L, 'name', 'Robot Planar RRPRP')
        disp(' ')
        disp('______________________________________________________________________')
        disp(' ')
        disp('a) oTg: Cinematica Directa c/ variaveis simbolicas:')
        disp('______________________________________________________________________')
        disp(' ')
        disp(oTg)
        disp(' ')
        disp('______________________________________________________________________')
    disp('#######################################################################')   
    end  
    
    %% PLOT DO ROBOT:
    
    if select == 2
        figure('units','normalized','outerposition',[0 0 1 1]);
         % Prespectiva de lado do Robot  
        subplot(1,2,1);
        robot.plot(q, 'workspace', [-10 90 -10 90 -10 90], 'reach', ... 
                       1, 'scale', 10, 'zoom', 0.25); % 'view', 'top', 'trail', 'b.');
                   
        % Prespectiva de topo do Robot -------------------------------------
        subplot(1,2,2);
        robot.plot(q, 'workspace', [-10 90 -10 90 -10 90],...
                      'reach', 1,...
                      'scale', 10,...
                      'zoom', 0.25,...
                      'view',...
                      'top'); % 'trail', 'b.');
                   
    disp('#######################################################################') 
    end  
    
    %% b) Obter a solu��o para a Cinem�tica inversa
    if select == 3
        
       
        disp(' ')
        disp('#######################################################################')
    end % fim da al�nea a)
    
    %% b) Calcule as express�es para a velocidade das juntas
    if select == 4
        disp('______________________________________________________________________')
        disp(' ')
        disp('b) Express�es para a velocidade das juntas c/ Vx = 10cm/s:')
        disp('______________________________________________________________________')
               
        % Restri��o na velocidade x em cm/s
        Vx = 10; 
        
        % Inversa da Jacobiana x Velocidades em XYZ 
        qVelocidades = inv(Jac_)*[ Vx 0 0 ]';  
        disp(' ')
        disp('Express�es para a velocidade das juntas c/ Vx = 10cm/s:')
        disp(' ')
        disp(qVelocidades)
      
        
    disp('#######################################################################')    
    end % fim da alinea b)
    
    %% d) Movimento do manipulador com malha de controlo
    
    if select == 5
        
       % sub-menu
       while(select2 ~= STOP2)
           
           select2 = menu('Seleccione a abordagem desejada: ', 'Integrador',...
                                                               'Malha-Fechada',...
                                                               'Back');
           %#######################################################################        
           
           % Velocidades impostas:
           Vx = 0;
           Vy = 20; % que permite seguir a pe�a // ao Eixo Y
           Wz = pi;
           
           % Posi��o Final do Gripper
           Xf = bTf(1,4); Yf = 30;
                              
           % Per�odo de Amostragem dos Controladores 
           h = 0.1;
           
           % Inicializa as Juntas segundo a Matriz Home/Posi��o Inicial
           %[ q_controlo ] = inverse_kinematics_ex2(bTf);
           
           q_controlo = q(1:3); 
           
           % 1. Abordagem Integradora
           if select2 == 1
               
               k = 1;
               
               while(bTf(2,4,k) < Yf) % && bTf(1,4) < Xf)
                   
                   % [ Vx vy Vz ] -> Idealmente Vx e Vz = 0 mas! vamos ver
                   % que o ponto x ir� ter um erro em rela��o ao inicial
                   % sendo que com o controlo em malha fechada pretende-se
                   % corrigir tal erro!
                   V(k,:) = [ Vx Vy Vz ];
                   
                   % Inversa do Jacobiano x Velocidades em XYZ
                   qVelocidades_ = inv(Jac_)*V(k,:)';
                   % Calculo da Inversa do Jacobiano
                   qVelocidades(:,k) = eval(subs(qVelocidades_, q_aux,...
                                     [ q_controlo(k,1:3) q(4:5) ] ));
                   
                   % Proximas Juntas segundo a Lei de Controlo: Abordagem Integradora
                   q_controlo(k+1,:) = q_controlo(k,:) + h*qVelocidades(:,k)';
                   
                   % tx e ty atrav�s da Matriz da Cinem�tica Directa
                   bTf(:,:,k+1) = eval(subs(oTg, q_aux,...
                                [ q_controlo(k,1:3) q(4:5) ] ));
                   
                   clc
                   disp(' ')
                   disp(['Loading... ', num2str((k/32)*100), '%'])
                   
                   % Atendendo que que theta4 e d5 s�o constantes:
                   q_out(k,:) = [q_controlo(k,1) q_controlo(k,2) q_controlo(k,3) q(4:5)];
                   pos_out(k,:) = bTf(1:3,4,k);
                   
                   k = k + 1;
               end
               
               % PLOT do Rob� com velocidades
               plot_robot2(robot, k, V, qVelocidades, q_out, pos_out);
               
           end
           %#######################################################################           
           % 2. Abordagem em malha-fechada
           if select2 == 2
               
               % Controlo Propocional kp > 0.65 Instav�l 
               kp = 0.75; % 0.01; s� com o k*h*qVelocidades e c/ 0.1 c/ kd = 0.01 temos bons results!
               % Controlo Derivativo
               kd = 0.01;
               
               % Posi��o Inicial!
               tx_desej = bTf(1,4);
               ty_desej = bTf(2,4);
               tz_desej = 5; % bTf(3,4)
               
               % Deslocamento = Velocidade*Per�odo IDEAL!
               dx = Vx*h; % IDEALMENTE � 0! Queremos manter a pos X
               dy = Vy*h;
               dz = Vz*h; % IDEALMENTE � 0! Queremos manter a pos Z
               
               k = 1;
               
               while(bTf(2,4,k) < Yf) % && bTf(1,4) < Xf)
                   
                   % [ Vx vy Vz ]
                   V(k,:) = [ Vx Vy Vz ];
                   
                   % Inversa do Jacobiano x Velocidades em XYZ
                   qVelocidades_ = inv(Jac_)*V(k,:)';
                   % Calculo da Inversa do Jacobiano
                   qVelocidades(:,k) = eval(subs(qVelocidades_, q_aux,...
                                     [ q_controlo(k,1:3) q(4:5) ] ));
                   
                   % Proximas Juntas: Controlo Malha fechada
                   q_controlo(k+1,:) = q_controlo(k,:) + 1*h*qVelocidades(:,k)';
                   
                   % tx e ty atrav�s da Matriz da Cinem�tica Directa
                   bTf(:,:,k+1) = eval(subs(oTg, q_aux,...
                                [ q_controlo(k,1:3) q(4:5) ] ));
                   
                   % ------------------------------------------------------
                   % Guardamos a Posi��o actual
                   tx_actual = bTf(1,4,k);
                   ty_actual = bTf(2,4,k);
                   tz_actual = bTf(3,4,k);
                  
                   % Posi��o desejada = Posi��o + Deslocamento IDEAL!
                   tx_desej = tx_desej + dx; % IDEALMENTE deve-se manter nos ~37
                   ty_desej = ty_desej + dy;
                   tz_desej = tz_desej + dz; % IDEALMENTE deve-se manter nos 5
                   
                   dx_erro = tx_desej - tx_actual;
                   dy_erro = ty_desej - ty_actual;
                   dz_erro = tz_desej - tz_actual;
                   
                   Vx = kp*dx_erro + kd*dx_erro/h; % dx_erro/h; %
                   Vy = kp*dy_erro + kd*dy_erro/h; % dy_erro/h; %
                   Vz = kp*dz_erro + kd*dz_erro/h; % dz_erro/h; %
                   
                   % NOTA: Como estamos a dividir o deslocamento a efectuar
                   % pelo Per�odo temos de imeadiato a velocidade a impor
                   % no caso c/ parte derivativa do controlo, esta
                   % corresponde acaba por corresponder a velocidade a impor
                   %
                   % Controlamos a velocidade Vx e Vz na tentativa de
                   % corrigir o erro em X e Z 
                   % ------------------------------------------------------        
                   clc
                   disp(' ')
                   disp(['Loading... ', num2str((k/90)*100), '%'])
                  
                   % Atendendo que que theta4 e d5 s�o constantes:
                   q_out(k,:) = [q_controlo(k,1) q_controlo(k,2) q_controlo(k,3) q(4:5)];
                   pos_out(k,:) = bTf(1:3,4,k);
                   
                   k = k + 1;
               end
               
               % PLOT do Rob� com velocidades
               plot_robot2(robot, k, V, qVelocidades, q_out, pos_out);
 
           end
           %#######################################################################
           
       end % fim do sub-menu
      
    disp('#######################################################################')   
    end % fim da alinea d)   
end % fim do menu/ fim do exercicio

