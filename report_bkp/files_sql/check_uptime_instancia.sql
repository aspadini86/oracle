conn / as sysdba
--SET MARKUP HTML ON TABLE "class=V$RMAN_BACKUP_JOB_DETAILS cellspacing=0" ENTMAP OFF
--SET MARKUP HTML ON TABLE "class=tabela_status" ENTMAP OFF

--COL INICIO FORMAT A10 heading "<p class=left>INICIO</p>" 
--COL TERMINO FORMAT A10 heading "<p class=left>TERMINO</p>"
--COL TERMINO TIPO_BKP A10 heading "<p class=left>TIPO_BKP</p>"
--COL TAMANHO_BKP FORMAT A10 heading "<p class=left>TAMANHO_BKP</p>"
--COL STATUS_BKP FORMAT A10 heading "<p class=left>STATUS_BKP</p>"


spool /home/oracle/bin/report_bkp/status2.txt APPEND

set termout off feedback off verify off heading off echo off

--select trunc((sysdate-startup_time)) from v$instance;
select '<b>INSTANCIA ATIVA A</b>: '|| trunc((sysdate-startup_time))||' DIAS' from v$instance;

spool off
exit
