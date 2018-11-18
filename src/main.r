# Seteo de variables de ambiente para la configuración del programa
library(RMySQL)
library("lattice") # Instala esto: install.package(nombredelabiblioteca)
library("cluster") # Instalar
library('clusteval') # Instalar
library('clues') # install.packages("clues")


# Importo archivo de configuración para la ejecución del genetico
source("../config/config.r")
source("../config/credenciales.r")

# Importo funciones aplicadas al genetico
source("calculos.r")
source("inicializacion.r")
source("crossover.r")
source("mutacion.r")
source("seleccion.r")

# Conexion a base de datos
mydb = dbConnect(MySQL(), user=user, password=password, dbname=dbname, host=host)

query = paste("TRUNCATE resultadosGenetico;", sep="")
dbSendQuery(mydb, query)
query = paste("INSERT INTO resultadosGenetico (generacion, ano, config, maximo, media, mediana, minimo) VALUES ('0','", year, "','", modeInicializacion, modeSeleccionCrossover, modeCrossover, modeMutacion, modeSeleccion, "','0','0','0','0') ON DUPLICATE KEY UPDATE maximo = '0',  media = '0',  mediana = '0', minimo = '0';", sep="")
dbSendQuery(mydb, query)

#Datos Propuestos por el ministerio
clusterPropuesto=read.table("../tmp/clusterPropuesto.csv",header=F,";")
clusterMinisterio <- clusterPropuesto[,2]
names(clusterMinisterio) <- clusterPropuesto[,1]

# Lectura de datos
file = paste("../tmp/matriz", year, ".txt", sep="")
data = read.table(file,header=T,";")
rownames(data) = data[,1]
data = data[,2:ncol(data)]

# total de variables consideradas en el año
totalVariables = ncol(data)

# inicialización de la poblacion
print("Inicializando población P: Comenzando")
poblacionP = inicializacion(individuos, totalVariables, grupos, modeInicializacion)
print("Inicializando población P: Terminado")
#print(poblacionP)

i = 1
while (i <= generaciones){
#while (TRUE){ # Temporal, solo pruebas
	# inicio de ciclo para creación de población Q
	j = 1
	print(paste("Generando población Q en la generacion: ", i, ": Comenzando"))
	poblacionQ = poblacionP
	while (j <= individuos){
		# seleccion de elementos al crossover
		soluciones = seleccionCrossover(poblacionP, individuos, modeSeleccionCrossover)

		# crossover de las soluciones escogidas
		poblacionQ[[j]] = crossover(poblacionP[[soluciones[[1]]]],poblacionP[[soluciones[[2]]]],totalVariables,modeCrossover)

		print(paste("Crossover: ", (j/individuos) * 100, "% completado", sep=''))
		j = j + 1
	}
	poblacionQ = poblacionQ[order(unlist(lapply(poblacionQ, function(x) x$puntaje)), decreasing = TRUE)]
	print(paste("Generando población Q en la generacion: ", i, ": Terminado"))
	print(paste("Largo de la poblacion Q: ", length(poblacionQ), sep=''))
	# inicio de creación para población Q' (Proceso de mutación)
	j = 1
	print(paste("Generando población Q' en la generacion: ", i, ": Comenzando"))
	poblacionQPrima = poblacionQ
	while (j <= individuos){
		poblacionQPrima[[j]] = mutacion(poblacionQPrima[[j]], totalVariables, modeMutacion)
		print(paste("Mutacion: ", (j/individuos) * 100, "% completado", sep=''))
		j = j + 1
	}
	poblacionQPrima = poblacionQPrima[order(unlist(lapply(poblacionQPrima, function(x) x$puntaje)), decreasing = TRUE)]
	print(paste("Generando población Q' en la generacion: ", i, ": Terminado"))
	print(paste("Largo de la poblacion Q': ", length(poblacionQPrima), sep=''))
	# inicio de selección de soluciones
	print(paste("Ejecutando seleccion entre poblacion P y Q' en la generacion: ", i, ": Comenzando"))
	poblacionFinal = seleccion(poblacionP, poblacionQPrima, individuos, modeSeleccion)
	print(paste("Ejecutando seleccion entre poblacion P y Q' en la generacion: ", i, ": Terminado"))

	print(paste("Largo de la poblacion Final: ", length(poblacionFinal), sep=''))

	# Registro de valores correspondientes a la generación
	media = mean(unlist(lapply(poblacionFinal, function(x) x$puntaje)), decreasing = TRUE)
	mediana = median(unlist(lapply(poblacionFinal, function(x) x$puntaje)), decreasing = TRUE)
	max = poblacionFinal[[1]]$puntaje
	minimo = poblacionFinal[[individuos]]$puntaje

	# Almacenando registros en base de datos
	query = paste("INSERT INTO resultadosGenetico (generacion, ano, config, maximo, media, mediana, minimo) VALUES ('", i, "','", year, "','", modeInicializacion, modeSeleccionCrossover, modeCrossover, modeMutacion, modeSeleccion, "','", max, "','", media, "','", mediana, "','", minimo, "') ON DUPLICATE KEY UPDATE maximo = '", max, "',  media = '", media, "',  mediana = '", mediana, "',  minimo = '", minimo ,"';", sep="")
	dbSendQuery(mydb, query)

	# Asiganación para el siguiente ciclo de generación
	poblacionP = poblacionFinal

	# guardando solucion final en texto
	write.table(poblacionFinal[[1]]$solucion, file = paste('../tmp/', modeInicializacion, modeSeleccionCrossover, modeCrossover, modeMutacion, modeSeleccion, 'solucionesGeneracion', year, '_', i, '.csv', sep=''),row.names=TRUE, col.names=FALSE, sep=",")
	write.table(poblacionFinal[[1]]$cluster, file = paste('../tmp/', modeInicializacion, modeSeleccionCrossover, modeCrossover, modeMutacion, modeSeleccion, 'clusterGeneracion', year, '_', i, '.csv', sep=''),row.names=TRUE, col.names=FALSE, sep=",")

	i = i + 1	
}