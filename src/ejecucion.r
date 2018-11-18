



cantidadIteraciones = 1000
contador = 9
while (contador <= 1000){
	source("main.r")
	query = paste("INSERT INTO resultadosHistoricos SELECT ", contador,", ano, maximo, media, mediana FROM tesis_recintoshospitalarios.resultadosGenetico WHERE generacion = 100;", sep="")
	print(query)
	dbSendQuery(mydb, query)
	contador = contador + 1
}


