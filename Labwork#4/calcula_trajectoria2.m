
%% DESCRI��O: Implementa a equa��o polinomial de 3� ordem com componentes de posi��o e velocidade;
% garante que a traject�ria satisfaz uma posi��o e velocidade final
% desejada.
% - Continuidade e suavidade nas velocidades e acelera��es das juntas;
% - Evitar solicita��es desmesuradas e irregulares nos actuadores.
%###################################################################################################
% ARGUMENTOS: 
%       - <t> : vari�vel simb�lica para o tempo;
%
%       - <ti> : instante inicial (t = ti);
%
%       - <qi> : valor das juntas na posi��o inicial (t = ti);
%
%       - <qf> : valor das juntas na posi��o final;
%
%       - <delta_t> : diferen�a entre tempo no instante final e tempo no
%       instante inicial;
%
%       - <v_qi> : velocidade das juntas na posi��o inicial (com t = ti)
%
%       - <v_qf> : velocidade dsa juntas na posi��o final
%
%###################################################################################################

function [ pos, q_traj ] = calcula_trajectoria2(a_max, q, t, h)

% qA, qB, qC, deg2rad(300), t, h

syms theta1 theta2

ti = t(1);
tim = t(2)-t(1);
tiM = t(3)-t(2); 
tf = t(3);

% Primeiro tro�o 
a(:,1) = sign(q(2,:)-q(1,:))*abs(a_max);
ta(:,1) = tim - sqrt(tim^2 - (2.*(q(2,:)-q(1,:)))./a(:,1));
v_q(:,1) = (q(2,:)-q(1,:))./(tim-(1/2)*ta(:,1));

% Ultimo tro�o
a(:,2) = sign( q(2,:) - q(3,:) ) * abs( a_max );
ta(:,2) = tiM - sqrt(tiM^2 + (2.*(q(3,:)-q(2,:)))./a(:,2));
v_q(:,2) = (q(:,3)-q(:,2))./(tiM-(1/2)*ta(:,2));

% Tro�o Interm�dio
a(:,3) = sign(q(2,:)-q(1,:))*abs(a_max);
ta(:,3) = (v_q(:,2) - v_q(:,1))./a(:,3);

qi = q(1,:) + (1/2)*a(:,1).*ta(:,1).^2;
qim = qi + v_q(:,1).*(tim - ta(:,1) - (1/2) * ta(:,3));
qiM = qim + v_q(:,1).*ta(:,3) + (1/2) * a(:,3).*ta(:,3).^2;
qf = qiM + v_q(:,2).*(tiM - q(3,:) - (1/2).*ta(3,:));


for th=ti:h:tf
    for k=1:1:size(q,2)
        for i=1:2
            
            if( th >= ti && th < ta(i,1) )
                
            elseif()
                
            elseif()
                
            elseif()
                
            end
        end
    end
end

% count = 1;
% 
% for i=1:size(t,2)-1
%     for th=t(i):h:t(i+1)-h
%         for k=1:1:size(q,2)
% 
% 
%             qi = q(i,k);
%             qf = q(i+1,k);
%             v_qi = v_q(i,k);
%             v_qf = v_q(i+1,k);
%             
%             delta_t = tf - ti;
%             
%             q_traj(count,k) = qi +                                    ...  % a0
%                                                                       ...
%                               v_qi*(th - ti) +                        ...  % a1*t
%                                                                       ...
%                               ((3/delta_t^2)*(qf-qi)-(2/delta_t)*v_qi ...
%                               -(1/delta_t)*v_qf)*(th-ti)^2            ...  % a2*t^2
%                                                                       ...
%                               -((2/delta_t^3)*(qf-qi)-(1/delta_t^2)*  ...
%                               (v_qf+v_qi))*(th-ti)^3;                      % a3*t^3
%             
%         end
%         % Calcula posi��es
%         oTg_ = eval(subs(oTg, q_aux, q_traj(count,:)));
%         pos(count,:) = [ oTg_(1,4) oTg_(2,4) oTg_(3,4) ];
%         
%         count = count + 1;
%     end
% end
end


