#!/bin/bash
export HOME_DIR=/home/oracle/bin/report_bkp
export V1=""

# 
# OBTENDO INFORMAÇÃO DO TAMANHO DAS PARTIÇÕES
# E GERANDO UM ARQUVIO TEMPORARIO df_tmp.txt
df -PH  | grep -v boot | grep -v nfe_dir | grep -v 10.11.94.2  | grep -v tmpfs  > $HOME_DIR/df_tmp.txt


#
# FOR PARA FORMARTAR EM HTML A SAIDA DO ARQUIVO df_tmp.txt
# 
for i in $(seq 1 6) 
do
	# INSERINDO TAG <TD> PARA FORMATAR TABELA
	cat df_tmp.txt | awk '{print $'$i'}' | sed 's/^/<td> /' |  sed 's/$/   <\/td>/' > df_tmp_$i
	
	# ESSE PARAMETRO IRA NA PRIMEIRA LINHA DO ARQUIVO df_tmp_$i
	# E VAI INSERIR A TAG <TH> PARA DEIXAR A TABELA COM UMA APARECENCIA MELHOR. 
	sed -i '1s/<td>/<th scope=col>/' df_tmp_$i
	sed -i '1s/<\/td>/<\/th> /' df_tmp_$i
done

#
# AGORA VAMOS COMPATENAR TODOS OS ARQUIVOS PARA FORMAR A TABELA.
# E GEREI df_tmp_7
paste df_tmp_1 df_tmp_2 df_tmp_3 df_tmp_4 df_tmp_5 df_tmp_6  >> df_tmp_7

#
# AGORA VOU INSERIR A TAG <TR>
sed -i 's/^/<tr> /' df_tmp_7
sed -i 's/$/<\/tr>  /' df_tmp_7

#
# INSERINDO A TAG <TABLE>
sed -i '1s/^/<table class=tabela_status> /' df_tmp_7

#
# FECHAR A TAG <TABLE> NO FINAL DO ARQUVIVO
echo "</table>" >> df_tmp_7

#
# IMPRIMINDO SAIDO 
cat df_tmp_7

#
# LIMPANDO ARQUIVOS TEMPORARIOS 
rm -f df_tmp*
