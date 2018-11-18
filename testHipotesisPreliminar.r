args = commandArgs(trailingOnly=TRUE)
library(RMySQL)
setwd("/home/acarlier/tesis/")
source("config/credenciales.r")
library("PMCMRplus")

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

mydb = dbConnect(MySQL(), user=user, password=password, dbname=dbname, host=host)
dbListTables(mydb)

#Leer datos
archivo = paste("tmp/", args[1], "/", args[2], ".txt", sep="")

datos=read.table(archivo,header=T,";")

#Prueba estadítica v1
#pruebav1=posthoc.kruskal.dunn.test(v1 ~ clase, data=datos, p.adjust.method="holm") 

prueba1=kruskal.test( Prestacion ~ Complejidad, data=datos)
pvalue = prueba1$p.value
query = paste("INSERT INTO testHipotesisPreliminar (IdPrestacion, ano, PValue) VALUES ('", args[2], "','", args[1], "','", pvalue, "') ON DUPLICATE KEY UPDATE PValue = '", pvalue, "';", sep="")
print(query)
dbSendQuery(mydb, query)