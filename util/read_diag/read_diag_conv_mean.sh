#!/bin/bash

# Rutina para leer archivos diag 

# Parámetros

FECHA_INI="20181112 21"		#YYYYMMDD HH
CICLOS=2 			#Ciclos de análisis a procesar
MIEM=60				#Cantidad de miembros del ensamble
PATH_IN=/home/paola.corrales/datosmunin3/EXP/E6_long/ANA/
PATH_OUT=$PATH_IN

# Loop sobre cada fecha/ciclo de asiminlación

for TIEMPO in $(seq -f "%02g" 0 $((10#$CICLOS-1)) )

do
	FECHA=$(date -d "$FECHA_INI + $((10#$TIEMPO*3600)) seconds" +"%Y%m%d%H%M%S")
	echo "Procesando un nuevo análisis"
	echo "Ciclo: " ${TIEMPO} " de " ${CICLOS}
	echo "Fecha del análisis: " ${FECHA}
 	
		DIAG_NAME=diag_conv_ges.ensmean

  		# Namelist

		cat <<- EOF > namelist.conv
		&iosetup
		  infilename='$PATH_IN/$FECHA/diagfiles/$DIAG_NAME',
		  outfilename='$PATH_OUT/$FECHA/diagfiles/asim_conv_${FECHA}.ensmean',
 /

		EOF

	  	./read_diag_conv.x > log.txt
  
done
