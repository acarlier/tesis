# proceso de mutacion para algoritmo genetico

mutacion <- function(individuo, totalVariables, mode){
	if(mode == 'prioridad'){
		# mutación en base a algún criterio .... to do
	}
	else{
		i = 1
		while (i <= totalVariables){
			probabilidadDeCambio = sample(0:1,1,replace=T)
			if(probabilidadDeCambio == 1){
				# Se debe mutar en valor de la posicion i
				if(individuo$solucion[[i]] == 0){
					individuo$solucion[[i]] = 1
				}
				else{
					individuo$solucion[[i]] = 0
				}
			}
			i = i + 1
		}

		probabilidaddeCambio = sample(0:1,1,replace=T)
		if(probabilidadDeCambio == 1){
			# Se debe mutar en valor del metodo cluster
			if(individuo$solucion[[i]] == 1){
				#metodoCluster = c(2,3)
				metodoCluster = c(2) # Temporal, hasta agregar la tercera tecnica de cluster
				individuo$solucion[[i]] = sample(metodoCluster,1,replace=T)
			}
			else if (individuo$solucion[[i]] == 2){
				#metodoCluster = c(1,3)
				metodoCluster = c(1) # Temporal, hasta agregar la tercera tecnica de cluster
				individuo$solucion[[i]] = sample(metodoCluster,1,replace=T)
			}
			else if (individuo$solucion[[i]] == 3){
				metodoCluster = c(1,2)
				individuo$solucion[[i]] = sample(metodoCluster,1,replace=T)
			}
			else{
				metodoCluster = c(1,2,3)
				individuo$solucion[[i]] = sample(metodoCluster,1,replace=T)
			}
		}

		# agregando la cantidad de grupos al vector
		individuo$solucion[[i + 1]] = grupos

		# Calculando indicadores para el individuo
		individuo = creaIndividuo(individuo$solucion, year, tipoDistancia, metrica)
	}
	return(individuo)
}