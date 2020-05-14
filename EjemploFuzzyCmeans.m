%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo   a l g o r i t m o   d e   l a s  
%            F u z z y   c - m e d i a s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('fallecidospcrccaaparototal.mat')  % carga de datos X del ejemplo
K=3;                       % número de cluster
m=2;                       % parámetro de fcm, 2 es el defecto
MaxIteraciones=100; 
X=fallecidospcrccaaparototal;
% número de iteraciones
Tolerancia= 1e-5;          % tolerancia en el criterio de para
Visualizacion=0;           % 0/1
opciones=[m,MaxIteraciones,Visualizacion];
[center,U,obj_fcn] = fcm(fallecidospcrccaaparototal, K,opciones);
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


for K=1:3
    [cidx] = kmeans(X, K,'Replicates',10);
    [Bic_K,xi]=BIC(K,cidx,X);
    BICK(K)=Bic_K;
end
figure(2)
plot(2:K',BICK(2:K)','s-','MarkerSize',6,...
     'MarkerEdgeColor','r', 'MarkerFaceColor','r')
xlabel('K','fontsize',18)      % etiquetado del eje-x
ylabel('BIC(K)','fontsize',18) % etiquetado del eje-y


%% Representación de individuos
plot(fallecidospcrccaaparototal(cidx==1,1),fallecidospcrccaaparototal(cidx==1,2),'rs','MarkerSize',6,...
                  'MarkerEdgeColor','r', ...
                  'MarkerFaceColor','r');
hold on
plot(fallecidospcrccaaparototal(cidx==2,1),fallecidospcrccaaparototal(cidx==2,2),'bs',...
 'MarkerSize',6,'MarkerEdgeColor','b', 'MarkerFaceColor','b');

plot(fallecidospcrccaaparototal(cidx==3,1),fallecidospcrccaaparototal(cidx==3,2),'gs',...
 'MarkerSize',6,'MarkerEdgeColor','g', 'MarkerFaceColor','g');


xlabel('x_1','fontsize',18),ylabel('x_2','fontsize',18)
legend('Grupo 1','Grupo 2','Grupo 3'),axis('square'), box on
title('Algoritmo Fuzzy c-means','fontsize',18)
% Escritura del nivel de pertenencia de cada individuo
for i=1:size(fallecidospcrccaaparototal,1)%    text(Wholesalecustomersdata2(i,1),Wholesalecustomersdata2(i,2),num2str(grado_pertenecia(i)),'FontSize',16);
end
%print(1,'-depsc','resul_fcm')   % genera gráfico .eps en fichero   




