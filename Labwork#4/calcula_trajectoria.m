
%% DESCRI��O: Implementa a equa��o polinomial  de 3� ordem com componentes de posi��o e velocidade;
% garante que a traject�ria satisfaz uma posi��o e velocidade final
% desejada.
% - Continuidade e suavidade nas velocidades e acelera��es das juntas;
% - Evitar solicita��es desmesuradas e irregulares nos actuadores.
%###################################################################################################
% ARGUMENTOS: 
%       - <t> : vari�vel simb�lica para o tempo;
%
%       - <t0> : instante inicial (t = t0);
%
%       - <theta0> : valor das juntas na posi��o inicial (t = t0);
%
%       - <thetaf> : valor das juntas na posi��o final;
%
%       - <delta_t> : diferen�a entre tempo no instante final e tempo no
%       instante inicial;
%
%       - <v_juntas0> : velocidade das juntas na posi��o inicial (com t = t0)
%
%       - <v_juntasf> : velocidade dsa juntas na posi��o final
%
%###################################################################################################

function [posicao] = calcula_trajectoria(t, t0, theta0, thetaf, delta_t, v_juntas0, v_juntasf)

posicao =                                                                              ...
                                                                                       ...
theta0 +                                                                               ... % a0
v_juntas0*(t - t0) +                                                                   ... % a1*t
((3/delta_t^2)*(thetaf-theta0)-(2/delta_t)*v_juntas0-(1/delta_t)*v_juntasf)*(t-t0)^2 - ... % a2*t^2
((2/delta_t^3)*(thetaf-theta0)-(1/delta^2)*(v_juntasf-v_juntas0))*(t-t0)^3;                % a3*t^3

end