clear all
close all
clc

disp('%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%    [Rob�tica - 10/10/2017 ~ 05/11/2017] LABWORK#2 - PROBLEMA 1    %%')
disp('%%                                                                   %%')
disp('%%                   Frederico Vaz, n� 2011283029                    %%')
disp('%%                   Paulo Almeida, n� 2010128473                    %%')
disp('%%                                                                   %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

%%  Tabela Denavith-Hartenberg

syms theta1 theta2 theta3
syms d1 d2 d3
syms alfa1 alfa2 alfa3
syms a1 a2 a3
syms offset1 offset2 offset3

%         thetai  di  alfai  ai  offseti  sigmai

PJ_DH = [ theta1  d1  alfa1  a1  offset1      0;
          theta2  d2  alfa2  a2  offset2      0;
          theta3  d3  alfa3  a3  offset3      0 ];
      
    

% C�lculo da cinem�tica directa i.e Transforma��es da junta 1 a junta 3
[ T1_2, Ti ] = direct_kinematics(PJ_DH);

disp(' ')
disp('Matriz de Transforma��o do elo/junta 1:')
disp(' ')
disp(Ti(:,:,1))

disp(' ')
disp('Matriz de Transforma��o do elo/junta 2:')
disp(' ')
disp(Ti(:,:,2))

disp(' ')
disp('Matriz de Transforma��o do elo/junta 3:')
disp(' ')
disp(Ti(:,:,3))

disp(' ')
disp('Cinem�tica directa da elo/junta 1 a elo/junta 3 de um rob�:')
disp(' ')
disp(T1_2)

