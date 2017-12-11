
%% Fun��o que calcula a matriz Jacobiana de velocidades do "end-effector"
%###################################################################################################
% ARGUMENTOS: 
%       - <oTg> : matriz de transforma��o simb�lica obtida a partir da
%         cinem�tic directa dos par�metros de Denavit-Hartenberg;
%
%       - <Ti> : um conjunto de matrizes elementares obtidas a partir da
%         da aplicão dos par�metros de Denavit-Hartenberg para cada uma das
%         juntas (1 matriz/junta);
%
%       - <q> : vector que cont�m os par�metros do manipulador a controlar,
%         se se tratar de uma junta rotacional o par�metro ser� do tipo
%         "theta_" ou se pelo contr�rio for uma junta prism�ticao
%         par�metro � da forma "d_";
%
%       - <joint_type> : um vector , cont�m 0's e 1's para identificar o tipo
%         de junta do manipulador (rotacional ou prism�tica);
%
%###################################################################################################

%%
function Jac = Jacobian(oTg, Ti, q, joint_type)

    syms dt
    
    % calcular velocidade linear
   
    % 1º ir buscar as posi��o atrav�s da matriz de transforma��o do robot 
    % para o gripper:
    
    tx = oTg(1,4);
    ty = oTg(2,4);
    tz = oTg(3,4);
    
    % Jacobiana de velocidades lineares - Matriz Jv
    for i = 1 : size(q,2)
        J_v(1,i) = diff(tx, q(i));
        J_v(2,i) = diff(ty, q(i));
        J_v(3,i) = diff(tz, q(i));
    end   

    % Calcular velocidade angular

    % caso particular: primeira junta
    I = eye(3,3);   % ºRo
    Rot = eye(3,3); % esta matriz � uma matriz de rota��o cumulativa entre as juntas do manipulador
    
    J_w(:,1) = I*[0 0 1]' * joint_type(1);  
    
    
    %Para as restantes juntas
    for i = 2 : size(q,2)
        
        Rot = Rot * Ti(1:3, 1:3, i-1); %i=2»0R1, i=3»0R2, i=4»0R3, i=5»0R4, i=6»0R5
        
        J_w = [J_w      Rot * [0 0 1]' * joint_type(i)]; % actualiza a matriz com o valor actual, a multiplicão cumulativa
        
    end
    % se a junta prism�tica joint_type = 0, o que d� uma velocidade angular nula
    % devolve vector "qsi", contem as duas componentes de velocidade das juntas
    % do robot, velocidade linear e velocidae angular

    Jac = [J_v ; J_w];


end















