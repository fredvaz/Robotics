
%% Fun��o da Cinem�tica Inversa do Robot
%  Consultar Ex2_Inversa.pdf, para melhor compreens�o da implementa��o

function [ theta1, theta2, d3 ] = inverse_kinematics_ex2(oTg)

% Partindo do Vector t
tx = oTg(1,4);
ty = oTg(2,4);
tz = oTg(3,4);

theta1 = atan2(ty,tx);

theta2 = atan2(tx*cos(theta1) + ty*sin(theta1), tz - 50);

d3 = (cos(theta1) * sin(theta2) * tx) +...
     (sin(theta1) * sin(theta2) * ty) +...
     (cos(theta2) * (tz - 50));
 
%--------------------------------------------------------------------------

end