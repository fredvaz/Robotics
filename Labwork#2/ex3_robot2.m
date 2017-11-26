clear all
close all
clc

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%    [Robotica - 10/10/2017 ~ 05/11/2017] LABWORK#2 - PROBLEMA 3   %%')
disp('%%                                                                  %%')
disp('%%                   Frederico Vaz, n. 2011283029                   %%')
disp('%%                   Paulo Almeida, n. 2010128473                   %%')
disp('%%                                                                  %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

%% Problema 3 - Obtenha os parametros de D-H dos 3 manipuladores

disp('************************************** ROBOT 2 *********************************************')
syms d2 theta1 theta3 theta4 theta5
L1 = 0.25;
%joint type
R = 1; %junta de rota��o
P = 0; %junta prism�tica

%valores do robot (arbitr�rios)
q = [pi/4 2 0 pi/4 pi/4];


disp('############################################################################################')
% Robot 2 [RP + RRR]- Matriz dos parametros de Denavith-Hartenberg: PJ_DH2
disp(' ')
disp('Robot 2 - Matriz dos parametros de Denavith-Hartenberg: PJ_DH')
disp(' ')


%           thetai  di     ai   alphai  offseti  sigmai
PJ_DH = [   theta1   0      0     pi/2     pi/2       1;  % Junta de rotacao
                 0  d2      0        0        2       0;  % Junta prismatica
            theta3   0      0    -pi/2        0       1;  % Punho esferico
            theta4   0      0     pi/2        0       1;  % Punho esferico
            theta5  L1      0        0        0       1]; % Punho esferico


%parametros de Denavit-Hartenberg
disp(PJ_DH)

disp('############################################################################################')


%%
select = 0;
sair = 4;

while(select ~= sair)    
    
    select = menu('Seleccione a ac��o a realizar:', 'alinea a) & b)',...
                                                    'a) & b) confirma��o dos resultados',...
                                                    'alinea c)',...
                                                    'sair do programa');  
    %% a) & b) Representa��o grafica dos robots c/ o punho esf�rico
    if select == 1

        % Valores Juntas - "home"
        q = [0 0 0 0 0];
        
        %junta rotacional 1
        L(1) = Link('d',eval(PJ_DH(1,2)), 'a', eval(PJ_DH(1,3)), 'alpha', eval(PJ_DH(1,4)), 'qlim', [0 pi]);
                
        %junta prism�tica 2
        L(2) = Link('theta', eval(PJ_DH(2,1)), 'a', eval(PJ_DH(2,3)), 'alpha', eval(PJ_DH(2,4)), 'qlim', [0 1]);

        %punho esf�rico
        for i=3:5
            L(i) = Link('d',eval(PJ_DH(i,2)), 'a', eval(PJ_DH(i,3)), 'alpha', eval(PJ_DH(i,4)));
        end
        
        %'SerialLink' cria um robot a partir dos objectos do tipo <Link>
        robot = SerialLink(L, 'name', 'Robot2');
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        robot.teach(q, 'workspace', [-2 2 -2 2 -1 2], 'reach',1); % "drive" a graphical robot using a graphical slider panel
        
    end
    %% a) e b) confirma��o dos dados
    if select == 2
        
        %matriz de transforma��o da "hand"(H) para o "robot"(0), simb�lica
        [ T0_H, Ti ] = direct_kinematics(PJ_DH);
        
        % matriz de transforma��o de T0_H obtida pela fun��o MGD_DH(PJ_DH)(nossa 'direct_kinematics(PJ_DH)')...
        % substituindo as vari�veis por valores atribuidos no vector q[];
        T0_H_values = eval(subs(T0_H, [d2 theta1 theta3 theta4 theta5], q));
        
        %obter a mesma substitui��o mas agora usando a fun��o 'fkine' da toolbox em
        %vez da 'direct_kinematics()
        T0_H_Toolbox = robot.fkine(q);
        
    
        disp('Matriz de transforma��o para cinematica Directa obtida com MGD_DH() c/ variaveis simbolicas:')
        disp('____________________________________________________________________________________')
        T0_H = simplify(T0_H);
        disp(T0_H)
        disp('____________________________________________________________________________________')

        disp(' ')
        disp('Matriz transforma��o obtida com MGD_DH() e com os valores atribuidos em q[]')
        disp('____________________________________________________________________________________')
        disp(T0_H_values)
        disp('____________________________________________________________________________________')

        disp(' ')
        disp('Matriz de transforma��o obtida com a toolbox e com os valores artribuidos em q[]')
        disp('____________________________________________________________________________________')
        disp(T0_H_Toolbox)
        disp('____________________________________________________________________________________')

        if(abs((T0_H_values - T0_H_Toolbox)) < 1e-15)
            disp('Os valores obtidos s�o coincidentes com os obtidos a partir da toolbox');
        else
            disp('As matrizes n�o coincidem!');
        end
    end
    %% c) Modelo inverso dos Robots
    if select == 3
        %obt�m Par�metros da Cinem�tica Inversa do robot
        PCI = inverse_kinematics_R2(T0_H);
        
        %substitui na matriz simb�lica
        T0_H_values_inv = eval(subs(T0_H, [d2 theta1 theta3 theta4 theta5], PCI));
        
        %obten��o dos par�metros de cinem�tica inversa usando a toolbox
        PCI_Toolbox = robo.ikine(T0_H, [0 0 0 0 0], [0 1 1 1 1 1]);

        %substitui-se os par�metros obtidos com a toolbox na matriz de
        %transforma��o para cinem�tica inversa 
        T0_H_Toolbox_inv = eval(subs(T_0G, [d1 d2 th3 th4 th5], PCI_Toolbox));
        

        if(abs((T0_H_values_inv - T0_H_Toolbox_inv)) < 1e-15)
            disp('Os valores obtidos s�o coincidentes com os obtidos a partir da toolbox');
        else
            disp('As matrizes n�o coincidem!');
        end
    end
    
end     %fim do menu