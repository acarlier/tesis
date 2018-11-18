# Función para determinar todos los indicadores asociados a una solucion

creaIndividuo <- function(vectorSolucion, year, tipoDistancia, metrica){
	# creando vector con datos para calculos iniciales
	individuo = NULL
	# Detalle de solucion
	# desglose solucion, largo del vector n + 2
	# (n) : variables consideradas
	# (n + 1) : Tecnica de cluster 1: PAM: 2: KMeans
	# (n + 2) : Numero de clusters
	individuo$solucion = vectorSolucion #4 variables + TecnicaClusters + NumeroClusters
	# (m) : categorizacion de hospitales
	individuo$cluster = NULL #2 clusters
	# puntaje obtenido según metodo de evaluación
	individuo$puntaje = NULL # IJ

	# Asigna datos al vector según el vector solucion
	dataSolucion = data[,which(vectorSolucion[1:totalVariables] == 1)]
	rownames(dataSolucion) = rownames(data[,which(vectorSolucion[1:totalVariables] == 1)])

	# Creación de matriz de distancia para la nueva solución
	mat_dist=as.matrix(dist(dataSolucion, method = tipoDistancia))
	colnames(mat_dist)=rownames(dataSolucion)     #Agrega nombre a las columnas
	rownames(mat_dist)=rownames(dataSolucion)     #Agrega nombre a las filas

	if (as.numeric(unlist(individuo$solucion[totalVariables + 1])) == 1){

		#Aplicación de PAM con 5 grupos
		metodo=pam(as.dist(mat_dist), individuo$solucion[totalVariables + 2],diss = TRUE,do.swap=T)

		#El índice de jaccard con 2 cifras decimales es:
		jaccard=round(cluster_similarity(metodo$clustering,clusterMinisterio, similarity = metrica, method = "independence"),6)
		individuo$cluster = metodo$clustering
		#individuo$puntaje = jaccard
		individuo$puntaje = as.numeric(adjustedRand(metodo$cluster, clusterMinisterio)[1])
		#print(individuo$puntaje)
		#print(as.numeric(adjustedRand(metodo$clustering, clusterMinisterio)[1]))
	}
	else if (as.numeric(unlist(individuo$solucion[totalVariables + 1])) == 2){
		#Aplicacion de Kmeans con 5 grupos
		metodo=kmeans(as.dist(mat_dist), individuo$solucion[totalVariables + 2])
		
		#El índice de jaccard con 2 cifras decimales es:
		jaccard=round(cluster_similarity(clusterMinisterio,metodo$cluster, similarity = metrica, method = "independence"),6)
		individuo$cluster = metodo$cluster
		#individuo$puntaje = jaccard
		individuo$puntaje = as.numeric(adjustedRand(metodo$cluster, clusterMinisterio)[1])
		#print(individuo$puntaje)
		#print(as.numeric(adjustedRand(metodo$cluster, clusterMinisterio)[1]))
	}
	else {
		# Tercer tecnica de cluster .... to do con paper del profe....

		
	}

	return(individuo)
}