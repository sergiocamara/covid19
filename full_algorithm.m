ccaa = readtable('fallecidos_pcr_ccaa_paro_total.csv').CCAA;
load('fallecidospcrccaaparototal.mat')  % carga de datos X del ejemplo
K=3;                       % número de cluster
m=2;                       % parámetro de fcm, 2 es el defecto
MaxIteraciones=100;        % número de iteraciones
file = fopen('fallecidos.txt','w');
X = fallecidospcrccaaparototal;

for n=3:size(fallecidospcrccaaparototal,2)
    cac = 1; % Columna a comparar
    % Datos para los que se va a hacer fuzzy c means
    %X=cat(2,fallecidospcrccaaparototal(:,cac),fallecidospcrccaaparototal(:,n));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Configuración de fuzzy c means
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Tolerancia= 1e-5;          % tolerancia en el criterio de para
    Visualizacion=0;           % 0/1
    opciones=[m,MaxIteraciones,Visualizacion];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Detección de outliers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N = size(X,1);
    for i=1:N
        X_sin_i=[X(1:(i-1),:);X((i+1):N,:)]; % eliminacion de la observación i
        [center,U,obj_fcn] = fcm(X_sin_i, K,opciones);
        SSE(i)=sum(obj_fcn);   % sumamos  de todas las distancias al cuadrado intraclusters obteniedo SSE
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Detección analítica
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sigma=std(SSE);    % desviación típica
    mu=mean(SSE);      % media
    umbral=1;          % umbral = 2 para distribuciones normales
    % umbral = 3 para cualquier ditribución
    outliers=[];       % inicialización del vector de outliers
    for i=1:N
        if abs(SSE(i)-mu)>umbral*sigma
            outliers=[outliers,i];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eliminación de outliers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N_outliers=length(outliers);
    indices=1:N;           % indices asociados a todos los datos
    indices_base = indices;
    for i=1:N_outliers
        indices=indices(indices~=outliers(i)); % elimina el outlier(i)
    end
    X=X(indices,:);        % datos sin outliers
    ccaa_sin_outliers={ccaa{indices,:}};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Test de hipótesis
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [center,U,obj_fcn] = fcm(X, K, opciones);
    cidx = [];
    for i=1:K
        maxU=max(U); % calculo del máximo nivel de pertenencia de los individuos
        individuos=find(U(i,:)==maxU); % calcula los individuos del grupo i que alcanzan el máximo
        cidx(individuos)=i;            % asigna estos individuos al grupo i grado_pertenecia(individuos)=maxU(individuos);
    end
    
    % Añadir información acerca de qué comunidad pertenece a qué grupo
    for nnn=1:size(cidx,2)
        fprintf(file, "%s : %d,", ccaa_sin_outliers{nnn}, cidx(nnn)); 
    end
    
    GRUPO1=(X(cidx==1,:));
    GRUPO2=(X(cidx==2,:));
    GRUPO3=(X(cidx==3,:));
    
    rng('default')
    variables = {'Fallecidos','Contagiados','Paro Total','Paro Hombre < 25','Paro Hombre 25-45','Paro Hombre > 45','Paro Mujer < 25','Paro Mujer 25-45','Paro Mujer > 45','Paro Sin empleo anterior','Paro agricultura','Paro construcción', 'Paro Industria','Paro Servicios'};

    pproducto = anova1(X(:,cac),cidx); % bucle análisis de varianza por producto
    fprintf(file, '\n\nanova -> %s p=% d\n', variables{n}, pproducto);
    if pproducto<0.05 % comparación de valor de probabilidad para determinar la varianza
        [p12,h12]= ranksum(GRUPO1(:,cac),GRUPO2(:,n)); % analisis de la varianza entre grupos por columna
        fprintf(file, 'ranksum -> GRUPO 1-2     p = %d | h =% d\n', p12, h12);
        [p13,h13]= ranksum(GRUPO1(:,cac),GRUPO3(:,n));
        fprintf(file, 'ranksum -> GRUPO 1-3     p = %d | h =% d\n', p13, h13);
        [p23,h23]= ranksum(GRUPO2(:,cac),GRUPO3(:,n));
        fprintf(file, 'ranksum -> GRUPO 2-3     p = %d | h =% d\n', p23, h23);
        [p21,h21]= ranksum(GRUPO2(:,cac),GRUPO1(:,n));
        fprintf(file, 'ranksum -> GRUPO 2-1     p = %d | h =% d\n', p21, h21);
        [p31,h31]= ranksum(GRUPO3(:,cac),GRUPO1(:,n));
        fprintf(file, 'ranksum -> GRUPO 3-1     p = %d | h =% d\n', p31, h31);
        [p32,h32]= ranksum(GRUPO3(:,cac),GRUPO2(:,n));
        fprintf(file, 'ranksum -> GRUPO 3-2     p = %d | h =% d\n', p32, h32);
    end
end
fclose(file);