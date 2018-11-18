# ensure results are repeatable
# load the library
library(mlbench)
library(caret)


year = '2014'
#Lectura de datos
# Lectura de datos
datos=read.csv(paste("../tmp/matriz", year, ".txt", sep=""),header=T,sep=";")

#Clase
clase=read.csv("../tmp/clusterPropuesto.csv",header=F,sep=";")


#Adicionar clase
datos=cbind(datos,clase[,2])
colnames(datos)[ncol(datos)]="clase"
datos$clase[which(datos$clase!=5)]=0      #1-baja, 2-alta adulto, 3-mediana, 4-ped, 5-psi
datos$clase=as.factor(datos$clase)

#Eliminación del nombre del hospital
datos=datos[,-1]

#Normal
for (a in 1:(ncol(datos)-1))
 {datos[,a]=(datos[,a]-min(datos[,a]))/(max(datos[,a])-min(datos[,a]))}


# prepare training scheme
control <- trainControl(method="repeatedcv", number=10, repeats=3)

# train the model
model <- train(clase~., data=datos, method="knn", preProcess="scale", trControl=control)

# estimate variable importance
importance <- varImp(model, scale=FALSE)

# summarize importance
print(importance)
# plot importance
plot(importance)

#Quantile() #<--calcula los percentiles