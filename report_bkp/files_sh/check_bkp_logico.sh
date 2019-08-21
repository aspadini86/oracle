#!/bin/bash
#########################################################################################
# DESENVOLEDOR: ANDRÉ SPADINI                                                           #
# DATA: 11/09/2015                                                                      #
# OBS.: CRIAR UM SCRIPT PARA ENVIAR EM FORMATO HTML O STATUS DO BACKUP FISICO E LOGICO  #
# DO ORACLE                                                                             #
#########################################################################################

#
# DECLARAÇÃO DE VARIAVEIS
source /home/oracle/.bash_profile
export DIR_BKP_LOGICO=/u02/bkp_logico
export HOME_DIR=/home/oracle/bin/report_bkp
export ARQ=$HOME_DIR/status.txt


#
# TRABALHANDO COM DATAS
export DATA1=$(date +%F)
export DATA2=$(date  --date="1 days ago" +%F)


# LISTA BACKUPS DISPONIVEIS NO LINUX
echo "<table class=\"tabela_status\">" 		>> $ARQ
echo "<tr><th>BACKUPS DISPONIVEIS</th> "       	>> $ARQ
echo "<th>TAMANHO</th> "       			>> $ARQ
echo "<th>STATUS</th> "       			>> $ARQ
echo "</tr>"					>> $ARQ

#
# VALIDANDO BKP DO DIA ATUAL
for i in $(echo $DATA1 $DATA2) 
do
	#
	# Aqui o cliente só possui os 2 ultimos backups 
	DATA=$(echo $i)
	export FILE_BKP_LOG=BKP_"$ORACLE_SID"_"$DATA".log
	export FILE_BKP_TGZ=BKP_"$ORACLE_SID"_"$DATA".tgz
	
	# VALIDANDO SE O ARQUIVO DE LOG EXISTE
	if [ -f $DIR_BKP_LOGICO/$FILE_BKP_LOG ]
	then 
		echo "<tr>"  >> $ARQ
	
		#
		# VALIDANDO SE A BASE FOI EXPORTADA COM SUCESSO. 
		if grep successfully $DIR_BKP_LOGICO/$FILE_BKP_LOG || grep sucesso $DIR_BKP_LOGICO/$FILE_BKP_LOG > /dev/null 2>&1
		then
			echo "<td> $(ls $DIR_BKP_LOGICO/$FILE_BKP_TGZ)"   				>> $ARQ
			echo "</td>"						 			>> $ARQ
			echo "<td> $(du -sh $DIR_BKP_LOGICO/$FILE_BKP_TGZ | awk '{print $1}' )"   	>> $ARQ 
			echo "</td>"						 			>> $ARQ
			echo "<td> COMPLETED </td>"							>> $ARQ
			
		else
			echo "<td> $(ls $DIR_BKP_LOGICO/$FILE_BKP_TGZ)"   				>> $ARQ
			echo "</td> "									>> $ARQ
			echo "<td> $(du -sh $DIR_BKP_LOGICO/$FILE_BKP_TGZ | awk '{print $1}' )" 	>> $ARQ
			echo "</td>"                                                                    >> $ARQ
			echo "<td> ERROR </td>"							>> $ARQ
		fi
		echo "</tr>"  >> $ARQ
	else
		#
		# SE O ARQUIVO DE LOG NAO EXISTIR 
		echo "<tr>"  							>> $ARQ
		echo "<td> $DIR_BKP_LOGICO/$FILE_BKP_LOG </td>" 		>> $ARQ
		echo "<td> ARQUIVO NAO EXISTE</td>" 				>> $ARQ
		echo "<td> ERROR </td>"						>> $ARQ
		echo "</tr>" 							>> $ARQ
	
	fi

done

echo "</table>" >> $ARQ

