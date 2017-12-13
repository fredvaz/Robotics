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

% Tempo:
tA = 0; % instante de tempo no ponto A (instante inicial da traject�ria)
tB = 8; % tempo final em [segundos], instante de tempo no ponto B (fim da traject�ria)
ti = 5; % instante de tempo em que o manipulador passa no ponto interm�dio, pi

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


%% PLOT DO ROBOT (para testar)

q_inicializacao = [ 0 0 0 0 ];
% 
% figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(1,2,1);
% robot.teach(q_inicializacao, 'workspace', [-10 40 -10 40 -10 40],...
%               'reach', 1,...
%               'scale', 10,...
%               'zoom', 0.25); % 'view', 'top', 'trail', 'b.');
          
  
          
%% transforma��es para os pontos que definem a traject�ria do mamnipulador

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
      
          
%% CINEM�TICA INVERSA

% OBTER A CONFIGURA��O DO MANIPULADOR (VALOR DAS JUNTAS) CORRESPONDENTE PARA OS PONTOS DA 
% TRAJECT�RIA DESEJADOS 

% valores das juntas para o ponto A
[ qA ] = inverse_kinematics_ex1(A_T_0);

% valores das juntas para o ponto interm�dio (pi)
[ qi ] = inverse_kinematics_ex1(i_T_0);

% valores das juntas para o ponto B
[ qB ] = inverse_kinematics_ex1(B_T_0);         
          
q_juntas = [qA' qi' qB'];

%% VELOCIDADES
T = [0 5 8]; %vector com os instantes dos pontos do percurso


%% PLANEAMENTO NO ESPA�O DAS JUNTAS

% NOTA: o vector <q> representa os valores das juntas 
                   

% 
% for t = 0 : 0.01 : 1
%     posicao = calcula_trajectoria(t, t0, tf, theta0, thetaf, delta_t, v_juntas0, v_juntasf);
% end
                   


