##INICIO DO ARQUIVO##

import smtplib
import sys
import commands
from email.MIMEText import MIMEText


le=commands.getoutput(' cat %s' % sys.argv[1])

try :
   server_ssl = smtplib.SMTP_SSL("smtp.gmail.com", 465)
   server_ssl.login("reportbkp@gmail.com","senha")
   msg1 = MIMEText("%s"% le, 'html')
   msg1['Subject']="DEPLOYT - UNIVERSAL - REPORT ORACLE"
   msg1['From']="reportbkp@gmail.com"
   msg1['To']="andre.spadini@deployit.com.br"
   server_ssl.sendmail("reportbkp@gmail.com","andre.spadini@deployit.group", msg1.as_string())
   server_ssl.close()
except Exception, e:
   print "Erro : %s" % e
else:
   print "Concluido"

##FINAL DO ARQUIVO##
