# -*- coding: utf-8 -*-
import os
import datetime
import subprocess
import pymysql.cursors
import sys
sys.path.append('/home/acarlier/tesis/config/')
import credenciales


# Connect to the database
connection = pymysql.connect(host=str(credenciales.get_host("local")),
                             user=str(credenciales.get_user("local")),
                             password=str(credenciales.get_password("local")),
                             db=str(credenciales.get_database("local")),
                             cursorclass=pymysql.cursors.DictCursor)


yearArray = ['2014', '2015', '2016', '2017', '2018']

for year in yearArray:
	
	#print("procesando año: " + str(year))
	with connection.cursor() as cursor:
		# Generando claves por año
		print("procesando claves del año: " + str(year))
		sql = "SELECT distinct IdPrestacion FROM detalleprestaciones WHERE ano ='" + str(year) + "'"
		cursor.execute(sql)
		claves = []
		for row in cursor:
			claves.append(row['IdPrestacion'])
			
		# Generando establecimientos por año
		print("procesando establecimientos del año: " + str(year))
		sql = "SELECT distinct IdEstablecimiento FROM detalleprestaciones WHERE ano ='" + str(year) + "'"
		cursor.execute(sql)
		establecimientos = []
		for row in cursor:
			establecimientos.append(row['IdEstablecimiento'])
		
		# Generando nueva estructura
		# print("generando string de salida: " + str(year))
		for clave in claves:
			salida = 'IdEstablecimiento;Prestacion;Complejidad\n'
			f= open("tmp/" + str(year) + "/" + str(clave) + ".txt","w+")
			f.write(salida)
			for establecimiento in establecimientos:
			
				# Obteniendo valores para variables
				sql = "SELECT Complejidad FROM complejidadHospitales WHERE IdEstablecimiento = '" + str(establecimiento) + "'"
				#print(sql)
				cursor.execute(sql)
				if cursor.rowcount == 0:
					complejidad = None
				else:
					for row in cursor:
						complejidad = str(row['Complejidad'])

				#print("consultando establecimiento - clave: " + str(establecimiento) + " - " + str(clave))
				sql = "SELECT detalleprestaciones.IdEstablecimiento, Complejidad, SUM(total) as total FROM detalleprestaciones LEFT JOIN complejidadHospitales ON detalleprestaciones.IdEstablecimiento = complejidadHospitales.IdEstablecimiento WHERE detalleprestaciones.IdEstablecimiento = '" + str(establecimiento) + "' AND IdPrestacion = '" + str(clave) + "' AND ano ='" + str(year) + "' AND Complejidad is not null GROUP BY detalleprestaciones.IdEstablecimiento, complejidadHospitales.Complejidad"
				cursor.execute(sql)

				for row in cursor:
					#print(row)
					if str(row['total']) == None and str(row['Complejidad'] != None):
						#print("entramos al if")
						salida = str(establecimiento) + ';0;' + str(row['Complejidad'] + '\n')
						#print(salida)
						f.write(salida)
					elif str(row['total']) != None and str(row['Complejidad'] != None):
						#print("entramos al elif")
						salida = str(establecimiento) + ';' + str(row['total']) + ';' + str(row['Complejidad'] + '\n')
						#print(salida)
						f.write(salida)
				if cursor.rowcount == 0 and complejidad != None:
					#print("entramos al final")
					salida = str(establecimiento) + ';0;' + str(complejidad) + '\n'
					#print(salida)
					f.write(salida)
		
			f.close()
			#Ejecucion en R para cada archivo
			print('ejecutando r para año: ' + str(year) + ' y clave: ' + str(clave))
			os.system("Rscript testHipotesisPreliminar.r " + str(year) + " " + str(clave))
			
'''
		sql = "SELECT * FROM detalleprestaciones WHERE ano ='" + str(year) + "'"
		cursor.execute(sql)
		yearDict = {}
		for row in cursor:
			try:
				yearDict[row['IdEstablecimiento']][row['IdPrestacion']] = row['total']
			except:
				yearDict[row['IdEstablecimiento']] = {}
				yearDict[row['IdEstablecimiento']][row['IdPrestacion']] = row['total']
'''
