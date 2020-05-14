%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           a l g o r i t m o   d e   l a s  
%            F u z z y   c - m e d i a s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear, clc   % cerrrar  ventanas gráficas 
                        % borrar memoria y  consola
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carga   d e   d a t o s 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('confirmados.mat')
Kmax=20;    % número máximo de cluster a analizar
X = confirmados;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C á l c u l o   d e l   B I C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for K=2:Kmax
    
    m=2;                       % parámetro de fcm, 2 es el defecto
    MaxIteraciones=100;        % número de iteraciones
    Tolerancia= 1e-5;          % tolerancia en el criterio de para
    Visualizacion=0;           % 0/1
    opciones=[m,MaxIteraciones,Visualizacion];
    [center,U,obj_fcn] = fcm(confirmados, K,opciones);
    %%%%%%%
    % p a r á m e t r o s   d e   s a l i d a              
    % center    centroides de los grupos
    % U         matriz de pertenencia individuo cluster 
    % obj_fun   función objetivo
    %%%%%%  Asignación de individuo a grupo, maximizando el nivel de
    %       pertenencia al grupo
    for i=1:K
    maxU=max(U); % calculo del máximo nivel de pertenencia de los
                 % individuos
    individuos=find(U(i,:)==maxU);% calcula los individuos del
                                  % grupo i que alcanzan el máximo
    cidx(individuos)=i;           % asigna estos individuos al grupo i
    grado_pertenecia(individuos)=maxU(individuos);

    end

    [Bic_K,xi]=BIC(K,cidx,X); %hacemos uso de la funcion BIC.m del mismo repositorio
    BICK(K)=Bic_K;
end
figure(2)
plot(2:K',BICK(2:K)','s-','MarkerSize',6,...
     'MarkerEdgeColor','r', 'MarkerFaceColor','r')
xlabel('K','fontsize',18)      % etiquetado del eje-x
ylabel('BIC(K)','fontsize',18) % etiquetado del eje-y