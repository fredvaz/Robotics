clear all
close all
clc

disp('%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%    [Rob�tica - 12/09/2017 ~ 08/10/2017] LABWORK#1 - PROBLEMA 4    %%')
disp('%%                                                                   %%')
disp('%%                   Frederico Vaz, n� 2011283029                    %%')
disp('%%                   Paulo Almeida, n� 2010128473                    %%')
disp('%%                                                                   %%')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')


%% Exerc�cio 8 - Constru�r um cubo a partir de 8 quadrados 
global square delay squareA squareB squareC squareD squareE squareF
% [ x y x ]4x3
n = 5; % size 
square = [ 0 0 0; % Ponto origem do referencial de cada quadrado
           n 0 0;
           n n 0;
           0 n 0  ];
       
delay = 0.0001
% Calibrar os referenciais
rTa = trans(0, 0, 0, [-5 0 0]');
rTb = trans(0, 0, 0, [-5 0 0]');
rTc = trans(0, 0, 0, [-5 0 0]');
rTd = trans(0, 0, 0, [0 0 0]');
rTe = trans(0, 0, 0, [0 0 0]');
rTf = trans(0, 0, 0, [0 -5 0]');





% Plot dos referencias de cada Square
figure('units','normalized','outerposition',[0 0 1 1])
 
subplot(2,3,1)
squareA = transPointsSquare(rTa, square);
drawSquare(squareA, 'b') ; 
title('face a')

subplot(2,3,2)
squareB = transPointsSquare(rTb, square);
drawSquare(squareB, 'r') ;
title('face b')

subplot(2,3,3)
squareC = transPointsSquare(rTc, square);
drawSquare(squareC, 'b') ;
title('face c')

subplot(2,3,4)
squareD = transPointsSquare(rTd, square);
drawSquare(squareD, 'r') ;
title('face d')

subplot(2,3,5)
squareE = transPointsSquare(rTe, square);
drawSquare(squareE, 'g');
title('face e')

subplot(2,3,6)
squareF = transPointsSquare(rTf, square);
drawSquare(squareF, 'g');
title('face f')

pause
%figure('units','normalized','outerposition',[0 0 1 1])
%% Configura��o no Mundo
% Criar 8 quadrados - Basta criar novos pontos atrav�s de Transforma��es
% Define-se a posi��o no mundo de cada um. A rota��o � indeferente
rTa = trans(0, 0, 0, [-10 0 0]');
rTb = trans(0, 0, 0, [-5 0 0]');
rTc = trans(0, 0, 0, [0 0 0]');
rTd = trans(0, 0, 0, [0 0 0]');
rTe = trans(0, 0, 0, [5  0 0]');
rTf = trans(0, 0, 0, [10  5 0]');


% Obten��o dos pontos dos Quadrados
% e Desenho dos quadrados no ambiente de trabalho
animateSquare(rTa, rTb, rTc, rTd, rTe, rTf);

%% Montagem do Cubo
figure('units','normalized','outerposition',[0 0 1 1])
for i=0:1:180
    
    
    % Rela��o dos pontos do A no referencial do B
    bTa = trans_inverse(rTb) * rTa;
    
    % Rela��o dos pontos do B no referencial do C
    cTb = trans_inverse(rTc) * rTb;
     
    % 1� Rodar C
    rTc_1 = rTc * trans(0, i/2, 0, [0 0 0]');
    
    % 2� Rodar B - implica conhecer rTc_1 ("ultima posi��o" do referencial de
    % B que � C), a rela��o cTb e ent�o aplicar a transforma��o que pretendemos em B
    rTb_1 = rTc_1 * cTb * trans(0, i/2, 0, [0 0 0]'); 
    
    % 3� Rodar A - implica conhecer rTb_1 ("ultima posi��o" do referencial de
    % A que � B) a rela��o bTa e ent�o aplicar a transforma��o que pretendemos em A
    rTa_1 = rTb_1 * bTa * trans(0, i/2, 0, [0 0 0]');
    
    %4� Rodar 180� em OZ e -90� em OX para colocar o quadrado F num dos lados do cubo 
    rTf_1 = rTf * trans(i, 0, -i/2, [-5 0 0]');
    
    
    %5� Rodar -180� em OZ e 90� em OX para colocar o quadrado E no lado
    %oposto de F
    rTe_1 = rTe * trans(-i, 0, i/2, [0 0 0]');
    
    
    %por fim desenha todos os quadrados nas suas novas posi��es
    animateSquare(rTa_1, rTb_1, rTc_1, rTd, rTe_1, rTf_1);
    
end

% NOTAS:
%aTb = trans_inverse(rTa) * rTb; % ao fazer este fica no lado simetrico
%do referecial roda a mesma o vermelho...
% * rTa_1 - p�s mutiplicar faz rodar A em rela��o ao referencial de B


% RODAR SOBRE O EIXO OZ NA ORIGEM DO MUNDO


for i = 1:10:45
    
  % Rela��o dos pontos do A no referencial do B
    dTa = trans_inverse(rTd) * rTa_1;
    
    % Rela��o dos pontos do B no referencial do C
    dTb = trans_inverse(rTd) * rTb_1;
    
      % Rela��o dos pontos do C no referencial do D
    dTc = trans_inverse(rTd) * rTc_1;
    
    % Rela��o dos pontos do D no referencial do E
    dTe = trans_inverse(rTd) * rTe_1;
    
%       % Rela��o dos pontos do E no referencial do F
    dTf = trans_inverse(rTd) * rTf_1;
    
   
    rTa_2 = trans(-i, -i, i, [0 0 0]') * dTa;
    rTb_2 = trans(-i, -i, i, [0 0 0]') * dTb;
    rTc_2 = trans(-i, -i, i, [0 0 0]') * dTc;
    rTd_1 = rTd * trans(-i, -i, i, [0 0 0]');
    rTe_2 = trans(-i, -i, i, [0 0 0]') * dTe;
    rTf_2 = trans(-i, -i, i, [0 0 0]') * dTf;

    animateSquare(rTa_2, rTb_2, rTc_2, rTd_1, rTe_2, rTf_2);

end

% RODA O CUBO SOBRE O EIXO OZ DO MUNDO 360

while(1)
    for i = 0:10:720
        rTa_new = trans(i,0,0, [0 0 0]') * rTa_2;
        rTb_new = trans(i,0,0, [0 0 0]') * rTb_2;
        rTc_new = trans(i,0,0, [0 0 0]') * rTc_2;
        rTd_new = trans(i,0,0, [0 0 0]') * rTd_1;
        rTe_new = trans(i,0,0, [0 0 0]') * rTe_2;
        rTf_new = trans(i,0,0, [0 0 0]') * rTf_2;
        
        
        animateSquare(rTa_new, rTb_new, rTc_new, rTd_new, rTe_new, rTf_new);
        
    end
    
end







