
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carga   d e   d a t o s 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('confirmados_sinOutliers.mat')
K=3;                       % Número óptimo de clusters
m=2;                       % parámetro de fcm, 2 es el defecto
MaxIteraciones=100;        % número de iteraciones
Tolerancia= 1e-5;          % tolerancia en el criterio de para
Visualizacion=0;           % 0/1
opciones=[m,MaxIteraciones,Visualizacion];
[center,U,obj_fcn] = fcm(X, K,opciones);
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
%grado_pertenecia(individuos)=maxU(individuos);
  
end

GRUPO1=(X(cidx==1,:));
GRUPO2=(X(cidx==2,:));
GRUPO3=(X(cidx==3,:));



rng('default')
%variables = {'Fallecidos','Contagiados','Paro Total','Paro Hombre < 25','Paro Hombre 25-45','Paro Hombre > 45','Paro Mujer < 25','Paro Mujer 25-45','Paro Mujer > 45','Paro Sin empleo anterior','Paro agricultura','Paro construcción', 'Paro Industria','Paro Servicios'};
variables = {'Andalucía','Aragón','Principado de Asturias','Cantabria','Ceuta','Castilla y León','Castilla-La Mancha','Canarias','Cataluña','Extremadura','Galicia','Islas Baleares','Región de Murci','Comunidad de Madrid','Melilla','Comunidad Foral de Navarra','País Vasco','La Rioja','Comunidad Valenciana'};
for i=1: size(X,2)
    vv = anova1(X(:,i),cidx); % blúce análisis de varianza por producto
    texto = sprintf('\n\nanova -> %s p=% d',i,vv);
    disp(texto);
    
    
end    

