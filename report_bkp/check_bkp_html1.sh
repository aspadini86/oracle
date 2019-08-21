#!/bin/bash
#########################################################################################
# DESENVOLEDOR: ANDRÉ SPADINI															#
# DATA: 11/09/2015																		#
# OBS.: CRIAR UM SCRIPT PARA ENVIAR EM FORMATO HTML O STATUS DO BACKUP FISICO E LOGICO 	#
# DO ORACLE																				#
#########################################################################################

#
# DECLARAÇÃO DE VARIAVEIS 
source /home/oracle/.bash_profile
export DIRBKP=/u02/bkp_logico
export DATA=$(date +%F)
export HOME_DIR=/home/oracle/bin/report_bkp
export ARQ=$HOME_DIR/status.txt
export DIR_BKP_FISICO=/u02/fra/NBS/backupset/
export DIR_BKP_LOGICO=/u02/bkp_logico/*tgz
export DIAS_SRV_LIGADO=$(uptime | awk '{print $3}')

##
# REMOVENDO ARQUIVOS DE LOG ANTIGO. 
cd $HOME_DIR
rm -f $ARQ

#
# FUNCAO EMAIL
func_send_email () {
	/usr/bin/python $HOME_DIR/files_email/send_email_to_html.dc.py $ARQ
}

#
# BACKUP FISICO 
echo "<h5>  BACKUP FISICO - RMAN 	</h5>" >>$ARQ

# VERIFICANDO SE A INSTANCIA ESTÁ ATIVA
	if  ps aux |grep -v grep |grep -c "ora_pmon_"$ORACLE_SID > /dev/null 2>&1
        then
		echo "OK "
	else
                echo "ERROR - INSTANCIA $ORACLE_SID OFFLINE  <br>" >> $ARQ
                echo "INFO - SAINDO DO SCRIPT		     <br>" >> $ARQ

                func_send_email
                exit
        fi


	# VERIFICANDO SE O LISTENER ESTÁ ATIVO
        if tnsping $ORACLE_SID ; echo $? > /dev/null  > /dev/null 2>&1
        then
		echo "OK"
		
	else
                echo "ERROR - LISTENER $ORACLE_SID OFFLINE  <br>"     >> $ARQ
                echo "INFO - SAINDO DO SCRIPT  <br>"                  >> $ARQ

                func_send_mail
                exit
        fi

	# EXECUTANDO SCRIPTS PARA VALIDAÇÃO DO RMAN 
	sqlplus /nolog @"$HOME_DIR"/files_sql/check_rman.sql

	echo "<br>" >> $ARQ
	#
	# LISTANDO BACKUP DISPONIVEIS EM DISCOS 
	echo "<table class=\"tabela_status\">" >> $ARQ
        echo "<tr><th>BACKUPS DISPONIVEIS</th></tr> "       >> $ARQ
	for i in $( find $DIR_BKP_FISICO -type f | sort) 
	do 
		echo "<tr><td> $i </td></tr>" >> $ARQ 
	done
	echo "</table>" >> $ARQ


#
# BACKUP LOGICO
echo " <br>"  >> $ARQ
echo "<h5> BACKUP LOGICO - EXP </h5>" >> $ARQ

	sh "$HOME_DIR"/files_sh/check_bkp_logico.sh

###
### PARTICOES
### 
echo " <br>"  >> $ARQ 
echo " <h5> PARTICOES </h5>" >> $ARQ

sh "$HOME_DIR"/files_sh/check_filesystem.sh >> $ARQ

echo "<br>"  >> $ARQ
echo " <h5> TABLESPACE </h5>" >> $ARQ
	sqlplus /nolog @"$HOME_DIR"/files_sql/check_tablespace.sql

echo " <br>" >> $ARQ

/bin/cat "$HOME_DIR"/files_txt/faqs.txt  >> $ARQ

"$HOME_DIR"/check_bkp_html2.sh
