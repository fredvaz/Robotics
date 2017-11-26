%% Fun��o da Cinem�tica Inversa do Robot
%  Consultar Ex3_Inversa.pdf, para melhor compreens�o da implementa��o

function [ q ] = inverse_kinematics_ex3(oTg)

% Vector t
tx = oTg(1,4);

%-----------------------------------------
% theta1:
theta1 = atan2(10,tx);

% theta3:
theta3 = pi/2 - theta1;

% d2:
d2 = sqrt(tx^2 + 10^2);


q = [theta1 d2 theta3];


end