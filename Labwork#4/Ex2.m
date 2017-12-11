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
Ti  = simplify(Ti) ; % 3 matrizes: a �ltima � uma transforma��o de corpo r�gido( o gripper n�o tem junta)


%% INICIALIZA��O DO ROBOT: CRIAR LINKS


for i = 1 : size(PJ_DH,1)
    
    if PJ_DH(i,6) == R              % Juntas Rotacionais
        
        L(i) = Link('d',eval(PJ_DH(i,2)),...
                    'a', eval(PJ_DH(i,3)),...
                    'alpha', eval(PJ_DH(i,4)),...
                    'offset', eval(PJ_DH(i,5)),...
                    'qlim', [0 3/2*pi]);
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


%% POSI��O HOME

% vectores das posi��es desejadas:
a = sqrt(2)/2;
b = (2-sqrt(2))/2;

PA = [0 a b];
PB = [a a 1];
PC = [a 0 b];

% falta deerminar ------------------------
% bTf_posA
% bTf_posB
% bTf_posC
% ----------------------------------------


[ pos_A ] = inverse_kinematics_ex2(bTf_posA); %obt�m a posi��o em A (inicial)
[ pos_B ] = inverse_kinematics_ex2(bTf_posB); %obt�m a posi��o em B
[ pos_C ] = inverse_kinematics_ex2(bTf_posC); %obt�m a posi��o em C (final)




%% VELOCIDADES 

% Juntas em symbolic p/ resolver o Jacobiano
q_aux = [theta1 theta2];

% Construir jacobiana 2 partir dos par�metros calculados na cinem�tica inversa
Jac = Jacobian(oTg, Ti, q_aux, PJ_DH(:,6));
 

%% PLOT DO ROBOT


% configura��o do manipulador na posi��o A --------------------------------
figure('units','normalized','outerposition',[0 0 1 1]);
% Prespectiva de lado do Robot
subplot(1,3,1);
robot.plot(pos_A, 'workspace', [-5 5 -5 5 -5 5], 'reach', ...
    1, 'scale', 5, 'zoom', 1);

% configura��o do manipulador na posi��o B --------------------------------
figure('units','normalized','outerposition',[0 0 1 1]);
% Prespectiva de lado do Robot
subplot(1,3,2);
robot.plot(pos_B, 'workspace', [-5 5 -5 5 -5 5], 'reach', ...
    1, 'scale', 5, 'zoom', 1);

% configura��o do manipulador na posi��o C --------------------------------
figure('units','normalized','outerposition',[0 0 1 1]);
% Prespectiva de lado do Robot
subplot(1,3,3);
robot.plot(pos_C, 'workspace', [-5 5 -5 5 -5 5], 'reach', ...
    1, 'scale', 5, 'zoom', 1);
                   

%% PLANEAMENTO DO ESPA�O DAS JUNTAS

% NOTA: o vector <q> representa os valores das juntas 
                   

for t = 0 : 0.01 : 1
    posicao = calcula_trajectoria(t, t0, theta0, thetaf, delta_t, v_juntas0, v_juntasf);
end
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   

