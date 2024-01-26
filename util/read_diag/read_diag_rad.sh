#!/bin/bash

# Rutina para leer archivos diag de satelite 

# Parámetros

FECHA_INI="20181108 00"		#YYYYMMDD HH
CICLOS=30 			#Ciclos de análisis a procesar
MIEM=60				#Cantidad de miembros del ensamble
PATH_IN=/home/paola.corrales/datosmunin3/EXP/E9/ANA/
PATH_OUT=/home/paola.corrales/datosmunin3/EXP/E9/ANA/

   listall="amsua_metop-a mhs_metop-a hirs4_metop-a hirs2_n14 msu_n14 \
          sndr_g08 sndr_g10 sndr_g12 sndr_g08_prep sndr_g10_prep sndr_g12_prep \
          sndrd1_g08 sndrd2_g08 sndrd3_g08 sndrd4_g08 sndrd1_g10 sndrd2_g10 \
          sndrd3_g10 sndrd4_g10 sndrd1_g12 sndrd2_g12 sndrd3_g12 sndrd4_g12 \
          hirs3_n15 hirs3_n16 hirs3_n17 amsua_n15 amsua_n16 amsua_n17 \
          amsub_n15 amsub_n16 amsub_n17 hsb_aqua airs_aqua amsua_aqua \
          goes_img_g08 goes_img_g10 goes_img_g11 goes_img_g12 \
          pcp_ssmi_dmsp pcp_tmi_trmm sbuv2_n16 sbuv2_n17 sbuv2_n18 \
          omi_aura ssmi_f13 ssmi_f14 ssmi_f15 hirs4_n18 amsua_n18 mhs_n18 \
          amsre_low_aqua amsre_mid_aqua amsre_hig_aqua ssmis_las_f16 \
          ssmis_uas_f16 ssmis_img_f16 ssmis_env_f16 mhs_metop-b \
          hirs4_metop-b hirs4_n19 amsua_n19 mhs_n19 goes_glm_16 \
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

	if [ -f "$PATH_IN/$FECHA/diagfiles/diag_${SENSOR}_ges.ensmean" ]; then

		echo ${SENSOR} " existe, procesando"

#		 Loop sobre los miembros del emsable

		MIEMBRO=0
		while [[ $MIEMBRO -lt $MIEM ]];do
		
			ENSMEM=`printf %03g $((10#$MIEMBRO+1))`
			DIAG_NAME=diag_${SENSOR}_ges.mem${ENSMEM}

		# Namelist
		cat <<- EOF > namelist.rad
		&iosetup
		  infilename='$PATH_IN/$FECHA/diagfiles/${DIAG_NAME}',
		  outfilename='$PATH_OUT/$FECHA/diagfiles/asim_${SENSOR}_${FECHA}.mem${ENSMEM}',
 /

		EOF

	  	./read_diag_rad.x 
		echo "Miembro: " ${ENSMEM}
		(( MIEMBRO += 1 ))
		done
	else 
		continue
	fi
	done
done
