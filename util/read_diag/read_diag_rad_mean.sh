#!/bin/bash

# Rutina para leer archivos diag de satelite 

# Parámetros

FECHA_INI="20181108 00"		#YYYYMMDD HH
CICLOS=373 			#Ciclos de análisis a procesar
MIEM=60				#Cantidad de miembros del ensamble
PATH_IN=/home/paola.corrales/datosmunin3/EXP/EG3_long/ANA/
PATH_OUT=/home/paola.corrales/datosmunin3/EXP/EG3_long/ANA/

   listall="amsua_metop-a mhs_metop-a hirs4_metop-a hirs2_n14 msu_n14 \
          amsua_n15 amsua_n16 amsua_n17 \
          airs_aqua amsua_aqua \
          hirs4_n18 amsua_n18 mhs_n18 \
          mhs_metop-b \
          hirs4_metop-b hirs4_n19 amsua_n19 mhs_n19 abi_g16 \
          iasi_metop-a iasi_metop-b mhs_n19 atms_npp atms_n20 \
	  cirs-fsr_npp cris-fsr_n20"


# Loop sobre cada fecha/ciclo de asiminlación

for TIEMPO in $(seq -f "%02g" 0 $((10#$CICLOS-1)) )
do
	echo echo "Ciclo: " ${TIEMPO} " de " ${CICLOS}
	FECHA=$(date -d "$FECHA_INI + $((10#$TIEMPO*3600)) seconds" +"%Y%m%d%H%M%S")
        echo "Fecha del análisis: " ${FECHA}
	
	for SENSOR in $listall
	do
 	
		DIAG_NAME=diag_${SENSOR}_ges.ensmean
		if [ -f "$PATH_IN/$FECHA/diagfiles_ana/${DIAG_NAME}" ]; then
  		
		# Namelist
		echo ${SENSOR} " existe, procesando"
		cat <<- EOF > namelist.rad
		&iosetup
		  infilename='$PATH_IN/$FECHA/diagfiles/${DIAG_NAME}',
		  outfilename='$PATH_OUT/$FECHA/diagfiles/asim_${SENSOR}_${FECHA}.ensmean',
 /

		EOF

	  	./read_diag_rad.x #> log.txt
		else 
			continue
		fi

	done
done
