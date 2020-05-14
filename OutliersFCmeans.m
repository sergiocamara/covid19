%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           a l g o r i t m o   d e   l a s  
%            F u z z y   c - m e d i a s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear, clc   % cerrrar  ventanas gr�ficas 
                        % borrar memoria y  consola
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carga   d e   d a t o s 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('fallecidospcrccaaparototal.mat')
K=3;    % n�mero de cluster optimizado
X = fallecidospcrccaaparototal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Detecci�n de outliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = size(X,1)
for i=1:N
    X_sin_i=[X(1:(i-1),:);X((i+1):N,:)]; % eliminacion de la 
                                         % observaci�n i
                                          
    m=2;                       % par�metro de fcm, 2 es el defecto
    MaxIteraciones=100;        % n�mero de iteraciones
    Tolerancia= 1e-5;          % tolerancia en el criterio de para
    Visualizacion=0;           % 0/1
    opciones=[m,MaxIteraciones,Visualizacion];
    [center,U,obj_fcn] = fcm(X_sin_i, K,opciones);
   
   SSE(i)=sum(obj_fcn);   % sumamos  de todas las distancias 
                        % al cuadrado intraclusters obteniedo SSE                      
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% D e t e c c i � n   v i s u a l
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
plot(SSE)
xlabel('Dato i','fontsize',18)
ylabel('SSE eliminando el dato i','fontsize',18)
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% D e t e c c i � n   a n a l � t i c a 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma=std(SSE);    % desviaci�n t�pica
mu=mean(SSE);      % media 
umbral=1;          % umbral =2 para distribuciones normales
                   % umbral =3 para cualquier ditribuci�n
outliers=[];       % inicializaci�n del vector de outliers
for i=1:N
    if abs(SSE(i)-mu)>umbral*sigma
        outliers=[outliers,i];
    end
end
outliers            % impresi�n por pantalla de los outliers 

% se�alamos los outliers en la gr�fica
hold on
for i=1:length(outliers)
    dato=outliers(i);
    plot(dato,SSE(dato),'bo',...
    'MarkerSize',6,'MarkerEdgeColor','b', 'MarkerFaceColor','b')
    text(dato,SSE(dato),'Outlier','fontsize',18);
end

N_outliers=length(outliers);

% eliminacion;
indices=1:N;           % indices asociados a todos los datos 
indices_base = indices;
for i=1:N_outliers
    indices=indices(indices~=outliers(i)); % elimina el outlier(i)
end
X=X(indices,:);        % datos sin outliers


