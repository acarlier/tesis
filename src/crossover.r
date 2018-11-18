# proceso de crossover para algoritmo genetico

seleccionCrossover <- function(poblacion, individuos, mode){
	if(mode == 'prioridad'){
		# crossover priorizando soluciones con mayor indicador
		soluciones = NULL
		max = poblacion[[1]]$puntaje
		min = poblacion[[individuos]]$puntaje
		i = 1
		while (i <= 2){
			seleccionElemento = sample(1:100,1,replace=T)
			probabilidadDeCambio = runif(1,0.0, 1.0)
			puntajeNormalizado = (poblacion[[seleccionElemento]]$puntaje - min)/(max - min)
			if (puntajeNormalizado >= probabilidadDeCambio){
				soluciones[[i]] = seleccionElemento
				i = i + 1
			}
		}
	}
	else{
		soluciones = sample(1:individuos,2,replace=F)
	}
	return(soluciones)
}

crossover <- function(individuo1, individuo2, totalVariables, mode){
	if(mode == 'prioridad'){
		# crossover priorizando soluciones con mayor indicador
	}
	else{
		# creacion de mascara
		entrecruzamiento1 = individuo1
		entrecruzamiento2 = individuo1
		mascaraVector = sample(0:1,totalVariables,replace=T)
		i = 1
		while (i <= totalVariables){
			if(mascaraVector[[i]] == 0){
				entrecruzamiento1$solucion[[i]] = individuo1$solucion[[i]]
				entrecruzamiento2$solucion[[i]] = individuo2$solucion[[i]]
			}
			else{
				entrecruzamiento1$solucion[[i]] = individuo2$solucion[[i]]
				entrecruzamiento2$solucion[[i]] = individuo1$solucion[[i]]
			}
			i = i + 1
		}

		mascaraMetodoCluster = sample(0:1,1,replace=T)
		if (mascaraVector == 0){
			entrecruzamiento1$solucion[[i]] = individuo1$solucion[[i]]
			entrecruzamiento2$solucion[[i]] = individuo2$solucion[[i]]
		}
		else{
			entrecruzamiento1$solucion[[i]] = individuo2$solucion[[i]]
			entrecruzamiento2$solucion[[i]] = individuo1$solucion[[i]]
		}

		# agregando la cantidad de grupos al vector

		entrecruzamiento1$solucion[[i + 1]] = grupos
		entrecruzamiento2$solucion[[i + 1]] = grupos

		entrecruzamiento1 = creaIndividuo(entrecruzamiento1$solucion, year, tipoDistancia, metrica)
		entrecruzamiento2 = creaIndividuo(entrecruzamiento1$solucion, year, tipoDistancia, metrica)
	}
	if (entrecruzamiento1$puntaje > entrecruzamiento2$puntaje){
		return(entrecruzamiento1)
	}
	else{
		return(entrecruzamiento2)
	}
}