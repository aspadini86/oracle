##INICIO DO ARQUIVO##

import smtplib
import sys
import commands
from email.MIMEText import MIMEText


le=commands.getoutput(' cat %s' % sys.argv[1])

try :
   serv=smtplib.SMTP()
   smtpserver="172.31.1.59"
   serv.connect(smtpserver,25)
   serv.login("oracle@ccmtecnologia.com.br","P@$$ccmr00t210")
   #msg1 = MIMEText("%s"% le)
   msg1 = MIMEText("%s"% le, 'html')
   msg1['Subject']="GRUPO MOTOFORMOSA - REPORT ORACLE"
   msg1['From']="oracle@ccmtecnologia.com.br"
   msg1['To']="andre@ccmtecnologia.com.br"
   serv.sendmail("oracle@ccmtecnologia.com.br","andre@ccmtecnologia.com.br", msg1.as_string())
   serv.quit()
except Exception, e:
   print "Erro : %s" % e
else:
   print "Concluido"

##FINAL DO ARQUIVO##

