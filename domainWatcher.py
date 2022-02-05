import subprocess
import smtplib
import sys
from email.message import EmailMessage

domains = ["google.com", "facebook.com"]
emailUser= "test@gmail.com"
emailPasswort = 'passwort1'
emailServer= 'smtp.gmail.com'
emailPort = 465
emailReciever = ["1@test.de", "2@test.de"]

def send_mail(domainname):
    try:
        msg = EmailMessage()
        msg['From'] = emailUser
        msg.set_content(f"The domain {domainname} is free\n\n\nVG\nDomain watcher ") 
        msg['Subject'] = 'Domäne ist frei - domain watcher'
        msg['To'] = emailReciever
        server = smtplib.SMTP_SSL(emailServer, emailPort)
        server.login(emailUser, emailPasswort )
        server.send_message(msg)
        server.quit()

    except Exception as e:
        print(e)

if __name__ == '__main__':
   for i in domains:
        test = subprocess.Popen(["whois", i], stdout=subprocess.PIPE)
        output = str(test.communicate()[0])
        if output.find('Status: free') != -1:
            send_mail(domains)
