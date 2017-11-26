
%% Verifica se a Matriz � ortonomada segundo as condi��es:
% 1 se ortonormada
% 0 caso contrario.

function result = isOrtonomada(R)

    % 1� condi��o: Determinante = 1
    det_ = single( det(R) );
    
    % 2� condi��o: Matriz Inversa = Matriz Transposta
    Rtra = single( R' );
    Tinv = single( inv(R) );

    % 3� condi��o: Producto Vetorial de duas linhas igual � terceira
    L12 = single( cross( R(1,1:3) , R(2,1:3) ) );
    L3 = single( R(3,1:3) );

    % 4� condi��o: Normas de cada linha/coluna = 1
    R = single( R );
    
    % Norma das linhas 
    normline(1) = norm( R(1,1:3) ); 
    normline(2) = norm( R(2,1:3) ); 
    normline(3) = norm( R(3,1:3) ); 
    
    % Norma das colunas 
    normcolun(1) = norm( R(1:3,1) ); 
    normcolun(2) = norm( R(1:3,2) ); 
    normcolun(3) = norm( R(1:3,2) ); 
    
    % Verifica condi��o
    if det_ == 1 & L12 == L3 & Rtra == Tinv & normline == [1 1 1] & normcolun == [1 1 1]

        result = 1;
    else 
        result = 0;
    end
end