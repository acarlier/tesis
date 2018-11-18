# proceso de seleccion de algoritmo genetico dadas dos poblaciones

seleccion <- function(poblacion1, poblacion2, individuos, mode){
	poblacionFinal = poblacion1
	if(mode == 'prioridad'){
		# mutación en base a algún criterio .... to do
	}
	else{
		i = 1
		j = 1 # contador para soluciones de 1
		k = 1 # contador para soluciones de 2
		while(i <= individuos){
			if(poblacion1[[j]]$puntaje >= poblacion2[[k]]$puntaje){
				poblacionFinal[[i]] = poblacion1[[j]]
				j = j + 1
			}
			else{
				poblacionFinal[[i]] = poblacion2[[k]]
				k = k + 1
			}
			i = i + 1
		}
	}
	return(poblacionFinal)
}