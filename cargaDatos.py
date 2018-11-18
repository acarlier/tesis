# -*- coding: utf-8 -*-
import pymysql.cursors
import os
import datetime
import sys
sys.path.append('/home/acarlier/tesis/config/')
import credenciales

# Connect to the database
connection = pymysql.connect(host=str(credenciales.get_host("local")),
                             user=str(credenciales.get_user("local")),
                             password=str(credenciales.get_password("local")),
                             db=str(credenciales.get_database("local")),
                             cursorclass=pymysql.cursors.DictCursor)

path = 'datos/'
for filename in os.listdir(path):
	tiempoInicial = datetime.datetime.now()
	print("procesando archivo: " + filename + " a las " + str(tiempoInicial))
	if filename[-4:] == '.txt':
		rutaCompleta = path + "/" + filename
		f = open(rutaCompleta,"r")
		file = f.readlines()
		for line in file:
			lineaPreprocesada = line.replace('\"','')
			dato = lineaPreprocesada.split(";")
			if dato[0] != 'Mes':
				mes = dato[0]
				idServicio = dato[1]
				ano = dato[2]
				idEstablecimiento = dato[3]
				idPrestacion = dato[4]
				idRegion = dato[5]
				idComuna = dato[6]
				if filename[0:2] == 'A_':
					idSerie = 'A'
				elif filename[0:2] == 'D_':
					idSerie = 'D'
				else:
					idSerie = filename[0:2]
				if dato[7] == '':
					total = '0'
				else:
					total = dato[7].replace(',','.')
				with connection.cursor() as cursor:
					# Read a single record
					#sql = "INSERT INTO detalleprestaciones (Mes, IdServicio, Ano, IdEstablecimiento, IdPrestacion, IdRegion, IdComuna, IdSerie, total) VALUES (%s, %s) ON DUPLICATE KEY UPDATE total = %s"
					#cursor.execute(sql, (mes, idServicio, ano, idEstablecimiento, idPrestacion, idRegion, idComuna, idSerie, total, total))
					sql = "INSERT INTO detalleprestaciones (Mes, IdServicio, Ano, IdEstablecimiento, IdPrestacion, IdRegion, IdComuna, IdSerie, total) VALUES ('" + mes + "', '" + idServicio + "', '" + ano + "', '" + idEstablecimiento + "', '" + idPrestacion + "', '" + idRegion + "', '" + idComuna + "', '" + idSerie + "', '" + total + "') ON DUPLICATE KEY UPDATE total = '" + total + "'"
					#print(sql)
					cursor.execute(sql)
					connection.commit()
		f.close()
	tiempofinal = datetime.datetime.now()
	print("termino de procesamiento archivo: " + filename + " a las " + str(tiempofinal))
	tiempoProcesamiento = tiempofinal - tiempoInicial
	print("tiempo total de procesamiento: " + str(tiempoProcesamiento))
connection.close()
