#!/bin/bash

# Rutina para leer archivos diag 

# Parámetros

FECHA_INI="20181120 18"		#YYYYMMDD HH
CICLOS=67			#Ciclos de análisis a procesar
MIEM=60				#Cantidad de miembros del ensamble
PATH_IN=/home/paola.corrales/datosmunin/EXP/E8/ANA/
PATH_OUT=/home/paola.corrales/datosmunin/EXP/E8/ANA/

# Loop sobre cada fecha/ciclo de asiminlación

for TIEMPO in $(seq -f "%02g" 0 $((10#$CICLOS-1)) )

do
	FECHA=$(date -d "$FECHA_INI + $((10#$TIEMPO*3600)) seconds" +"%Y%m%d%H%M%S")
	FECHA_OUT=$(date -d"$FECHA_INI" +%Y%m%d%H)
	echo "Procesando un nuevo pronostico"
	echo "Ciclo: " ${TIEMPO} " de " ${CICLOS}
	echo "Fecha del análisis: " ${FECHA}
 	
	# Loop sobre los miembros del emsable

	MIEMBRO=0
	while [[ $MIEMBRO -lt $MIEM ]];do
		
		ENSMEM=`printf %03g $((10#$MIEMBRO+1))`
		DIAG_NAME=diag_conv_ges.mem${ENSMEM}
		echo "Miembro: " ${ENSMEM}

  		# Namelist

		cat <<- EOF > namelist.conv
		&iosetup
		  infilename='$PATH_IN/$FECHA/diagfiles/$DIAG_NAME',
		  outfilename='$PATH_OUT/$FECHA/diagfiles/asim_conv_${FECHA}.mem${ENSMEM}',
 /

		EOF

	  	./read_diag_conv.x > log.txt
  
		(( MIEMBRO += 1 ))
	done
done
