# seteo de variables de configuración para aplicación de genetico

# año de ejecución, 2014 - 2018
year = 2014

# cantidad de individuos a considerar en el calculo de la poblacion
individuos = 100

# default: Modo de configuración por default, probabilidad de 0.5 en cada seleccion
# asc: probabilidad ascendente a la hora de seleccionar las variables [0.1:0.9] en cada seleccion
# desc: probabilidad ascendente a la hora de seleccionar las variables [0.9:0.1] en cada seleccion
modeInicializacion = 'default'

# default: Modo de configuración por default, probabilidad de 0.5 en cada seleccion de soluciones a entrecruzar
# prioridad: seleccion de soluciones utilizando mayor probablidad en mejores soluciones
modeSeleccionCrossover = 'prioridad'

# default: Modo de configuración por default, probabilidad de 0.5 en cada seleccion de variables dentro de la solucion a entrecruzar
# prioridad: seleccion de variables en soluciones utilizando mayor probablidad en mejores soluciones
modeCrossover = 'default'

modeMutacion = 'default'
modeSeleccion = 'default'

# cantidad de grupos para cluster
grupos = 5

# ciclo de generaciones aplicadas al genetico
generaciones = 200

# variables para definir individuos
tipoDistancia = 'euclidean'
metrica = 'jaccard'