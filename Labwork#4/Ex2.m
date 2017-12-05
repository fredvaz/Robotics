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
disp('*************************** Exerc�cio 2 ******************************')

%% manipulador	 do	 tipo	 2

syms theta1 theta2

% Comprimentos dos elos:
L1 = 1;
L2 = 1;

% Junta Rotacional ou Prismatica:
R = 1; P = 0;
%_________________________________________________________________________________
%          thetai  |  di  |  ai |  alfai | offseti | jointtypei
%_________________________________________________________________________________
PJ_DH = [  theta1     L1      0     pi/2     pi/2           R;   % Junta Rotacional
%_________________________________________________________________________________
           theta2      0      0     pi/2        0           R;   % Junta Rotacional
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

% POSI��O HOME:


% q = [0 0 0];

[ q ] = inverse_kinematics_ex2(oTg);
% 
% q = eval([ q(1:3) 0 ]);
% 
% % Juntas em symbolic p/ resolver o Jacobiano
% q_aux = [ theta1 d2 theta3 ];
% 
% % Construir jacobiana 2 partir dos par�metros calculados na cinem�tica inversa
% Jac = Jacobian(oTg, Ti, q_aux, PJ_DH(:,6));
% 
% % Componentes de velocidade objectivo [ vx vy wz ]
% Jac_ = [ Jac(1:2, 1:3); Jac(6,1:3) ];

%% PLOT DO ROBOT

        figure('units','normalized','outerposition',[0 0 1 1]);
         % Prespectiva de lado do Robot  
        subplot(1,2,1);
        robot.teach(q, 'workspace', [-5 5 -5 5 -5 5], 'reach', ... 
                       1, 'scale', 5, 'zoom', 1);
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   

