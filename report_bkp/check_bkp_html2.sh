#!/bin/bash
#########################################################################################
# DESENVOLEDOR: ANDRÉ SPADINI								#
# DATA: 11/09/2015									#
# OBS.: CRIAR UM SCRIPT PARA ENVIAR EM FORMATO HTML O STATUS DO BACKUP FISICO E LOGICO 	#
# DO ORACLE										#
#########################################################################################

#
# DECLARAÇÃO DE VARIAVEIS 
source /home/oracle/.bash_profile
export DIRBKP=/u02/bkp_logico
export DATA=$(date +%F)
export HOME_DIR=/home/oracle/bin/report_bkp
export ARQ=$HOME_DIR/status.txt
export ARQ2=$HOME_DIR/status2.txt
export DIR_BKP_FISICO=/u02/fra/NBS/backupset/
export DIR_BKP_LOGICO=/u02/bkp_logico/*tgz
export DIAS_SRV_LIGADO=$(uptime | awk '{print $3}')

#
# REMOVENDO ARQUIVOS DE LOG ANTIGO. 
cd $HOME_DIR
rm -f $ARQ2

#
# IMPORTANDO CONFIGURAÇÃO DO CSS
cat $HOME_DIR/files_txt/chkbkp_css.txt >> $ARQ2

#
# CABEÇALHO DO MEAIL
echo "<h5>  RELATORIO DE ATIVIDADES DO SGBD ORACLE </h4>" >> $ARQ2
echo "<b>RELATORIO DE</b>:  $(date +%d/%m/%Y)				<br>" >> $ARQ2
echo "<b>NOME DO SERVIDOR</b>: $(hostname)			<br>" >> $ARQ2
echo "<b>SERVIDOR LIGADO A</b>: $DIAS_SRV_LIGADO DIAS  <br> ">> $ARQ2
sqlplus /nolog @"$HOME_DIR"/files_sql/check_uptime_instancia.sql
echo "<br>" >> $ARQ2

if grep -i ERROR $ARQ || grep -i ALERT $ARQ ||  grep -i FAIL $ARQ || grep -i '100%' $ARQ || grep -i '99%' $ARQ  > /dev/null 2>&1
then
       	echo "<b>STATUS:</b><font color=red> IDENTIFICAMOS ALGUNS ALERTAS NA SUA ROTINA</font></br>" >> $ARQ2
        cat $ARQ >> $ARQ2
else
	echo "<b>STATUS:</b><font color=green> TODAS AS ROTINAS ABAIXO FORAM EXECUTADAS COM SUCESSO!</font> </br>" >> $ARQ2
	echo "<br>"
        cat $ARQ >> $ARQ2
fi

/usr/bin/python $HOME_DIR/files_email/send_email_to_html.dc.py $ARQ2
