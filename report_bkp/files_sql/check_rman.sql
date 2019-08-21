conn / as sysdba
--SET MARKUP HTML ON TABLE "class=V$RMAN_BACKUP_JOB_DETAILS cellspacing=0" ENTMAP OFF
SET MARKUP HTML ON TABLE "class=tabela_status" ENTMAP OFF

--COL INICIO FORMAT A10 heading "<p class=left>INICIO</p>" 
--COL TERMINO FORMAT A10 heading "<p class=left>TERMINO</p>"
--COL TERMINO TIPO_BKP A10 heading "<p class=left>TIPO_BKP</p>"
--COL TAMANHO_BKP FORMAT A10 heading "<p class=left>TAMANHO_BKP</p>"
--COL STATUS_BKP FORMAT A10 heading "<p class=left>STATUS_BKP</p>"


spool /home/oracle/bin/report_bkp/status.txt APPEND

set termout off feedback off verify off heading on echo off

select          to_char(start_time,'dd/mm/yyyy hh24:mi') INICIO,
                to_char(end_time,'dd/mm/yyyy hh24:mi') TERMINO,
                input_type TIPO,
                output_bytes_display TAMANHO,
                status STATUS
from V$RMAN_BACKUP_JOB_DETAILS
where input_type='DB FULL' and start_time > sysdate-2
order by start_time desc;


spool off
exit
