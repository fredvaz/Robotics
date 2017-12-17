clear all
close all
clc

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%                                                                  %%')
disp('%%                   PLANEAMENTO DE TRAJECT�RIAS                    %%')
disp('%%                                                                  %%')
disp('%%          [Rob�tica - 28/11/2017 ~ 17/12/2017] LABWORK#4          %%')
disp('%%                                                                  %%')
disp('%%                   Frederico Vaz, n� 2011283029                   %%')
disp('%%                   Paulo Almeida, n� 2010128473                   %%')
disp('%%                                                                  %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ')
disp('*************************** Exerc�cio 1 ******************************')

%% VARI�VEIS GLOBAIS

syms theta1 d2 theta3

% Comprimentos dos elos:
L2 = 10;

% Junta Rotacional ou Prismatica:
R = 1; P = 0;

%% MODELO DE CINEM�TICA DIRECTA DO MANIPULADOR (NOTA: o modelo cinem�tico directo � semelhante ao robot
% implementado no Labwork#3, ex3)


%_________________________________________________________________________________
%          thetai  |  di  |  ai |  alfai | offseti | jointtypei
%_________________________________________________________________________________
PJ_DH = [  theta1      0      0     pi/2     pi/2           R;   % Junta Rotacional
%_________________________________________________________________________________
                0     d2      0    -pi/2        0           P;   % Junta Prism�tica
%_________________________________________________________________________________
           theta3      0      0     pi/2        0           R;   % Junta Rotacional
%_________________________________________________________________________________
                0     L2      0        0        0           R ]; % Indiferente (N�o aplic�vel)
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

% Tempo:
tA = 0; % instante de tempo no ponto A (instante inicial da traject�ria)
tB = 8; % tempo final em [segundos], instante de tempo no ponto B (fim da traject�ria)
ti = 5; % instante de tempo em que o manipulador passa no ponto interm�dio, pi

% transforma��es para os pontos que definem a traject�ria do mamnipulador

A_T_0 = [ 0   0.9659    0.2588   21.4720 ;
          0   -0.2588   0.9659   22.1791 ;
          1     0         0         0    ;
          0     0         0         1   ];
      
i_T_0 = [ 0   0.9659    0.2588   26.2396 ;
          0   -0.2588   0.9659   15.9659 ;
          1     0         0         0    ;
          0     0         0         1   ];
      
B_T_0 = [ 0   0.8660     -0.5     12.0   ;
          0    0.5      0.8660   22.5167 ;
          1     0         0         0    ;
          0     0         0         1   ];
    
      
% CINEM�TICA INVERSA

% OBTER A CONFIGURA��O DO MANIPULADOR (VALOR DAS JUNTAS) CORRESPONDENTE PARA OS PONTOS DA 
% TRAJECT�RIA DESEJADOS 

% Valores das juntas para o ponto A
[ qA ] = inverse_kinematics_ex1(A_T_0);

% Valores das juntas para o ponto interm�dio (pi)
[ qi ] = inverse_kinematics_ex1(i_T_0);

% Valores das juntas para o ponto B
[ qB ] = inverse_kinematics_ex1(B_T_0);         
  
% Vector com os instantes de passagem nos pontos do percurso 
t = [ 0 5 8 10 15 18 20 25 28 ];

% Vector c/ valor das juntas nos pontos de passagens
q = [ qA; qi; qB; qA; qi; qB; qA; qi; qB ]; % Se fizermo para mais instantes � reptir estes pontos

% C�lcula as velocidades para cada junta em cada instante 
v_q = calcula_velocidade(q, t);

% Per�o de amostragem 
h = 0.2;

% C�lcula traject�ria para as respectivas juntas
[ pos, q_traj ] = calcula_trajectoria(oTg, t, q, v_q, h);


%% MENU ("main")

% Variaveis MENU
select = 0;
STOP = 4;

while(select ~= STOP)
    
    select = menu('Seleccione a acao a realizar:', 'Home',...
                                                   'Trajectoria',...
                                                   'Mover Robot',...
                                                   'Quit');  
                                               
    %% PLOT DO ROBOT:
    if select == 1
        figure('units','normalized','outerposition',[0 0 1 1]);
         % Prespectiva de lado do Robot  
        subplot(1,2,1);
        robot.plot([q(1,:) 0], 'workspace', [-10 60 -10 40 -10 30], 'reach', ... 
                       1, 'scale', 10, 'zoom', 0.5); % 'view', 'top', 'trail', 'b.');
                   
        % Prespectiva de topo do Robot -------------------------------------
        subplot(1,2,2);
        robot.plot([q(1,:) 0], 'workspace', [-10 60 -10 40 -10 30],...
                      'reach', 1,...
                      'scale', 10,...
                      'zoom', 0.5,...
                      'view',...
                      'top'); % 'trail', 'b.');
                   
    disp('#######################################################################') 
    end 
     %% a) Express�es que permitem calcular os valores dos coeficientes das fun��es polinomiais
    if select == 2
        disp('______________________________________________________________________')
        disp('Trajectoria efectuada pelo rob�.')
        disp('______________________________________________________________________')
               
        plot(pos(:,1), pos(:,2), 'r');
        title('Trajectoria a efectuar pelo Robo');
        xlabel('X')
        ylabel('Y')
        %xlim([0 k-1])
        %ylim([-5 5])
        grid on
        
        disp('#######################################################################')
    end % fim da alinea a)
    
    %% b) Movimento do manipulador segundo a traject�ria acima planeada
    
    if select == 3
        
        % Plot segundo o Controlador
        figure('units','normalized','outerposition',[0 0 1 1]);
        % Prespectiva de lado do Rob�
        subplot(1,2,1);
        robot.plot([q_traj(1,:) 0], 'workspace', [-10 60 -10 40 -10 30], 'reach', ... % [-40 60 -10 100 -10 70]
            1, 'scale', 10, 'zoom', 0.5); % 'view', 'top', 'trail', 'b.');
        % Prespectiva de topo do Rob�
        subplot(1,2,2);
        robot.plot([q_traj(1,:) 0], 'workspace', [-10 60 -10 40 -10 30], 'reach', ...
            1, 'scale', 10, 'zoom', 0.5, 'view', 'top'); % 'trail', 'b.');
        
        for i=1:size(q_traj,1)
            
            robot.animate([q_traj(i,:) 0]);
            
        end
    end
    %
end