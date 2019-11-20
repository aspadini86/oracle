#!/bin/bash

source /home/oracle/.bash_profile

$ORACLE_HOME/bin/sqlplus / AS SYSDBA <<EOF

EXEC STATSPACK.PURGE(I_NUM_DAYS=>7,I_EXTENDED_PURGE=>TRUE);
EXIT;

EOF
