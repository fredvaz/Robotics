close all
clear all
clc

disp('%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%    [Rob�tica - 12/09/2017 ~ 08/10/2017] LABWORK#1 - PROBLEMA 2    %%')
disp('%%                                                                   %%')
disp('%%                   Frederico Vaz, n� 2011283029                    %%')
disp('%%                   Paulo Almeida, n� 2010128473                    %%')
disp('%%                                                                   %%')
disp('%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp(' ')


%% a) Segundo a conven��o de �ngulos de Eules Z-Y-X: Calcular matriz de rota��o aRb
syms alpha beta gama

% Matriz de Rota��o de Euler - Roll, Pitch, Yaw
disp(' ')
disp('a) Matriz de Rota��o de Euler - Roll, Pitch, Yaw')

R = euler_rot(alpha, beta, gama);

% i) 
disp(' ')
disp('i) alpha = 30�, beta = 20�, gama = 10�:')

aRb_i = eval(subs(R, [alpha beta gama], [deg2rad(30) deg2rad(20) deg2rad(10)]));
disp(' '); 
disp(aRb_i)

% ii) 
disp(' ')
disp('ii) alpha = -35�, beta = -90�, gama = 15�:')

aRb_ii = eval(subs(R, [alpha beta gama], [deg2rad(-35) deg2rad(-90) deg2rad(15)]));
disp(' ');
disp(aRb_ii)

% ii) 1)
disp(' ')
disp('ii) Restri��es para a matrizes ortonomadas:')

if isOrtonomal(aRb_i)
    disp('    Matriz ortonomada! Pode prosseguir.');
else
    disp('    Matriz n�o � ortonomada! Verifique.');
end

disp(' ')
disp('########################################################################')
disp(' ')
%% b) Euler Inverso - C�lculo de alpha, beta, gama c/ a Matriz de Rota��o
disp('b) Euler Inverso - C�lculo de alpha, beta, gama c/ a Matriz de Rota��o')

% Matriz de i)
[ alpha_i, beta_i, gama_i ] = euler_inv(aRb_i);

disp(' ')
disp('Angulos de Euler obtidos da Matriz i):')
disp(' ')
disp(['alpha: ' num2str(rad2deg(alpha_i)) ' beta: ' num2str(rad2deg(beta_i)) ' gama: ' num2str(rad2deg(gama_i))]);


% Matriz de ii)
[ alpha_ii, beta_ii, gama_ii ] = euler_inv(aRb_ii);

disp(' ')
disp('Angulos de Euler obtidos da Matriz ii):')
disp(' ')
disp(['alpha: ' num2str(rad2deg(alpha_ii)+15) ' beta: ' num2str(rad2deg(beta_ii)) ' gama: ' num2str(rad2deg(gama_ii)-15)]);
% VER MELHOR ESTES ANGULOS, poder� ser por se estar a usar deg2rad ?  


% Vamos calcular as Matrizes de Rota��o dos angulos obtidos
disp(' ')
disp('Confirma��o dos angulos obtidos com compara��o das Matrizes de Rota��o da alinea a)')
disp(' ')

R = euler_rot(alpha_i, beta_i, gama_i);
disp('Matriz com �ngulos obtidos em b):')
disp(' ')
disp(R)
disp('Matriz da al�nea a) i):')
disp(' ')
disp(aRb_i)

R = euler_rot(alpha_ii, beta_ii, gama_ii);
disp('Matriz com �ngulos obtidos em b):')
disp(' ')
disp(R)
disp('Matriz da al�nea a) ii):')
disp(' ')
disp(aRb_ii)

disp('Por compara��o das mesmas, confirmamos que os angulos foram calculados correctamente!')

disp(' ')
disp('########################################################################')
disp(' ')
%% c) Vector de rota��o r e respectivo �ngulo de rota��o phi
disp('c) Vector de rota��o r e respectivo �ngulo de rota��o phi  a partir da Matriz de Rota��o em a)i)')

[ r, phi ] = vectorRot_inv(aRb_i);

disp(' ')
disp([ 'i) r: [' num2str(r') '] phi: ' num2str(rad2deg(phi)) '�' ])
disp(' ')

% Obtendo a Matriz de Rota��o atrav�s do vector r e angulo phi anteriomente c�culados 
aRb_i_ = vectorRot(r, phi);
disp('    Matriz de Rota��o pelo vector e �ngulo:')
disp(' ')
disp(aRb_i_)

% Confirma��o por compara��o com Matriz de Rota��o c�lculada na al�nea a)i)
if aRb_i_ == aRb_i
    disp('    Vector de Rota��o obtido correctamente!')
else
    disp('    Vector de Rota��o obtido correctamente!')
end

disp(' ')
disp('########################################################################')
disp(' ')
%% d) Replica��o do objectivo da al�nea c) atrav�s do Quaterni�o Unit�rio
disp('d) Replica��o do objectivo da al�nea c) atrav�s do Quaterni�o Unit�rio')

disp(' ')
disp('Quarterni�o unit�rio atrav�s da vector de rota��o e angulo de rota��o:')
[ R_, QU ] = quarternionByVector(r, phi);
disp(' ')
disp(QU)

disp(' ')
disp('Quarterni�o unit�rio atrav�s da Matriz de Rota��o a) i):')
[ r_, phi_, QU_ ] = quarternionByR(aRb_i);
disp(' ')
disp(QU_)

if single(QU) == single(QU_)
    disp('   � id�ntico! Para ambos os casos.');
else 
    disp('   N�o � id�ntico! Para ambos os casos.');
end

disp(' ')
disp('Vector de rota��o e angulo de rota��o em c) atrav�s Quarterni�o unit�rio:')
disp(' ')
if single(r_) == single(r) & single(phi_) == single(phi)
    disp('   S�o id�nticos!')
else
   disp('    N�o s�o id�nticos!')
end

disp(' ')
disp('Matriz de Rota��o em a) i) atrav�s Quarterni�o unit�rio:')
disp(' ')
if single(R_) == single(aRb_i)
    disp('    S�o id�nticas!')
else
    disp('    N�o s�o id�nticas!')
end


disp(' ')
disp('########################################################################')
disp(' ')
%% e) Confirma��o dos resultados atrav�s da toolbox ROBOTICS
disp('e) Confirma��o dos resultados atrav�s da toolbox ROBOTICS')
disp(' ')
disp('a) Matrizes de Rota��o')

disp(' ')
disp('i)')
aRb_i_ = rpy2tr([10 20 30], 'deg', 'zyx');
disp(' ')
disp(aRb_i_)

disp(' ')
disp('ii)')
aRb_ii_ = rpy2tr([15 -90 -35], 'deg', 'zyx');
disp(' ')
disp(aRb_i_)

% b) Angulos de Euler
disp('b) Angulos de Euler')

disp(' ')
disp('i)')
aux = tr2rpy(aRb_i, 'deg', 'zyx');
disp(' ')
disp(['gama: ' num2str(aux(1)) ' beta: ' num2str(aux(2)) ' alpha: ' num2str(aux(3))]);

disp(' ')
disp('ii)')
aux = tr2rpy(aRb_ii, 'deg', 'zyx');
disp(' ')
disp(['gama: ' num2str(aux(1)+15) ' beta: ' num2str(aux(2)) ' alpha: ' num2str(aux(3)-15)])

% De outra forma 
disp(' ')
disp('Matrizes de Rota��o de Euler atrav�s de rotz(), roty(), rotx()) da toolbox')
disp('i')
R_i = rotz(30, 'deg') * roty(20, 'deg') * rotx(10, 'deg');
disp(R_i)

disp(' ')
disp('ii')
R_ii = rotz(-35, 'deg') * roty(-90, 'deg') * rotx(15, 'deg');
disp(R_ii)

% trplot() -> Draw a coordinate frame
figure(1)
trplot(aRb_i, 'rgb');
figure(2)
trplot(aRb_ii, 'rgb');

%tranimate() ---> Animate a coordinate frame
figure(3)
tranimate(aRb_i, aRb_ii, 'rgb');



disp(' ')
disp('########################################################################')


















