# inicialización de población para procesamiento de algoritmo genetico

inicializacion <- function(individuos, totalVariables, grupos, mode){
	poblacion = NULL
	poblacion[[1]] = NULL
	# Detalle de solucion
	# desglose solucion, largo del vector n + 2
	# (n) : variables consideradas
	# (n + 1) : Tecnica de cluster 1: PAM: 2: KMeans
	# (n + 2) : Numero de clusters
	poblacion[[1]]$solucion = NULL #4 variables + TecnicaClusters + NumeroClusters
	# (m) : categorizacion de hospitales
	poblacion[[1]]$cluster = NULL #2 clusters
	# puntaje obtenido según metodo de evaluación
	poblacion[[1]]$puntaje = NULL # IJ

	# Inicialización en base a los parametros de entrada
	if (mode == 'asc'){
		# modo ascendente de probabilidades
		i = 1
		while (i <= individuos){
			# asignación temporal R
			poblacion[[i]] = poblacion[[1]]
			poblacion[[i]]$solucion = NULL

			# Vector de configuración para la seleccion de variables
			vectorSolucion = sample(0:1,totalVariables,replace=T)

			# Vector de configuración para la seleccion de variables
			j = 1
			prob = 1 - ((individuos - i )/individuos)
			while (j <= totalVariables){
				probabilidadDeSeleccion = runif(1,0.0, 1.0)
				if(probabilidadDeSeleccion < prob){
					vectorSolucion[[j]] = 1
				}
				else{
					vectorSolucion[[j]] = 0	
				}
				j = j + 1
			}
			# Agrega la técnica de cluster a utilizar
			vectorSolucion = append(vectorSolucion, sample(1:2,1,replace=T)) # agregando tecnica de cluster al vector solucion

			# Agrega la cantidad de grupos a considerar
			vectorSolucion = append(vectorSolucion, grupos) # agregando numero de clusters
			print(paste("Inicialización: ", (i/individuos) * 100, "% completado", sep=''))
			poblacion[[i]] = creaIndividuo(vectorSolucion, year, tipoDistancia, metrica)
			i = i + 1

		}
	}
	else if (mode == 'desc'){
		# modo descendente de probabilidades
		i = 1
		while (i <= individuos){
			# asignación temporal R
			poblacion[[i]] = poblacion[[1]]
			poblacion[[i]]$solucion = NULL

			# Vector de configuración para la seleccion de variables
			vectorSolucion = sample(0:1,totalVariables,replace=T)

			# Vector de configuración para la seleccion de variables
			j = 1
			prob = ((individuos - i )/individuos) + 0.001
			while (j <= totalVariables){
				probabilidadDeSeleccion = runif(1,0.0, 1.0)
				if(probabilidadDeSeleccion < prob){
					vectorSolucion[[j]] = 1
				}
				else{
					vectorSolucion[[j]] = 0	
				}
				j = j + 1
			}
			# Agrega la técnica de cluster a utilizar
			vectorSolucion = append(vectorSolucion, sample(1:2,1,replace=T)) # agregando tecnica de cluster al vector solucion

			# Agrega la cantidad de grupos a considerar
			vectorSolucion = append(vectorSolucion, grupos) # agregando numero de clusters
			print(paste("Inicialización: ", (i/individuos) * 100, "% completado", sep=''))
			poblacion[[i]] = creaIndividuo(vectorSolucion, year, tipoDistancia, metrica)
			i = i + 1

		}
	}
	else{
		# modo default de configuración. Probabilidad 0.5 en considerar cada variable
		i = 1
		while (i <= individuos){
			# asignación temporal R
			poblacion[[i]] = poblacion[[1]]
			poblacion[[i]]$solucion = NULL

			# Vector de configuración para la seleccion de variables
			vectorSolucion = sample(0:1,totalVariables,replace=T)

			# Agrega la técnica de cluster a utilizar
			vectorSolucion = append(vectorSolucion, sample(1:2,1,replace=T)) # agregando tecnica de cluster al vector solucion

			# Agrega la cantidad de grupos a considerar
			vectorSolucion = append(vectorSolucion, grupos) # agregando numero de clusters
			print(paste("Inicialización: ", (i/individuos) * 100, "% completado", sep=''))
			poblacion[[i]] = creaIndividuo(vectorSolucion, year, tipoDistancia, metrica)
			i = i + 1
		}
	}
	# orden de la poblacion en base a su puntaje
	poblacion = poblacion[order(unlist(lapply(poblacion, function(x) x$puntaje)), decreasing = TRUE)]

	#print(poblacion)

	# población final 
	return(poblacion)
}