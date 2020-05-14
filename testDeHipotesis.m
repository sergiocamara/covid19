
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carga   d e   d a t o s 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('fallecidospcrccaaparototal_sinOutliers.mat')
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
%GRUPO4=(X(cidx==4,:));
%GRUPO5=(X(cidx==5,:));

rng('default')
%variables = {'Fallecidos','Contagiados','Paro Total','Paro Hombre < 25','Paro Hombre 25-45','Paro Hombre > 45','Paro Mujer < 25','Paro Mujer 25-45','Paro Mujer > 45','Paro Sin empleo anterior','Paro agricultura','Paro construcción', 'Paro Industria','Paro Servicios'};
variables = {'Fallecidos','Paro Total'};
for i=1: size(X,2)
    pproducto = anova1(X(:,i),cidx); % blúce análisis de varianza por producto
    texto = sprintf('\n\nanova -> %s p=% d',variables{i},pproducto);
    disp(texto);
    if pproducto<0.05 %comparación de valor de probabilidad para determinar la varianza
        [p12,h12]= ranksum(GRUPO1(:,i),GRUPO2(:,i)); % analisis de la varianza entre grupos por columna
        texto1 = sprintf('ranksum -> GRUPO 1-2     p = %d | h =% d',p12,h12);
        disp(texto1);
        [p13,h13]= ranksum(GRUPO1(:,i),GRUPO3(:,i));
         texto2 = sprintf('ranksum -> GRUPO 1-3     p = %d | h =% d',p13,h13);
        disp(texto2);
        %[p14,h14]= ranksum(GRUPO1(:,i),GRUPO4(:,i));
         %texto3 = sprintf('ranksum -> GRUPO 1-4     p = %d | h =% d',p14,h14);
        %disp(texto3);
        %[p15,h15]= ranksum(GRUPO1(:,i),GRUPO5(:,i));
         %texto4 = sprintf('ranksum -> GRUPO 1-5     p = %d | h =% d',p15,h15);
        %disp(texto4);
        [p23,h23]= ranksum(GRUPO2(:,i),GRUPO3(:,i));
         texto5 = sprintf('ranksum -> GRUPO 2-3     p = %d | h =% d',p23,h23);
        disp(texto5);
        %[p24,h24]= ranksum(GRUPO2(:,i),GRUPO4(:,i));
         %texto6 = sprintf('ranksum -> GRUPO 2-4     p = %d | h =% d',p24,h24);
        %disp(texto6);
        %[p25,h25]= ranksum(GRUPO2(:,i),GRUPO5(:,i));
        % texto7 = sprintf('ranksum -> GRUPO 2-5     p = %d | h =% d',p25,h25);
        %disp(texto7);
        %[p34,h34]= ranksum(GRUPO3(:,i),GRUPO4(:,i));
        % texto8 = sprintf('ranksum -> GRUPO 3-4     p = %d | h =% d',p34,h34);
        %disp(texto8);
        %[p35,h35]= ranksum(GRUPO3(:,i),GRUPO5(:,i));
         %texto9 = sprintf('ranksum -> GRUPO 3-5     p = %d | h =% d',p35,h35);
        %disp(texto9);
        %[p45,h45]= ranksum(GRUPO4(:,i),GRUPO5(:,i));
        %texto10 = sprintf('ranksum -> GRUPO 4-5     p = %d | h =% d',p45,h45);
        %disp(texto10);
    end    
    
end    

