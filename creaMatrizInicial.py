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
		sql = "SELECT IdPrestacion FROM tesis_recintoshospitalarios.testHipotesisPreliminar WHERE PValue < 0.05 AND ano ='" + str(year) + "'"
		cursor.execute(sql)
		claves = []
		for row in cursor:
			claves.append(row['IdPrestacion'])
			
		# Generando establecimientos por año
		print("procesando establecimientos del año: " + str(year))
		sql = "SELECT IdEstablecimiento FROM tesis_recintoshospitalarios.complejidadHospitales"
		cursor.execute(sql)
		establecimientos = []
		for row in cursor:
			establecimientos.append(row['IdEstablecimiento'])
		
		# Generando nueva estructura
		# print("generando string de salida: " + str(year))
		f= open("tmp/matriz" + str(year) + ".txt","w+")
		salida = 'IdEstablecimiento;'
		for clave in claves:
			salida = str(salida) + str(clave) + ';'
		salida = salida[:-1] + '\n'
		f.write(salida)

		for establecimiento in establecimientos:
			salida = str(establecimiento) + ';'
			for clave in claves:
			
				# Obteniendo valores para variables
				sql = "SELECT SUM(total) as total FROM tesis_recintoshospitalarios.detalleprestaciones WHERE IdPrestacion = '" + str(clave) + "' AND IdEstablecimiento = '" + str(establecimiento) + "' AND Ano = '" + str(year) + "'"
				cursor.execute(sql)
				for row in cursor:
					if str(row['total']) == 'None':
						total = '0'
					else:
						total = str(row['total'])
				salida = str(salida) + str(total) + ';'
			salida = salida[:-1] + '\n'
			f.write(salida)
	f.close()