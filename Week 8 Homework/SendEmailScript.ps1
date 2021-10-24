# Storyline: Send an email.

# Body of the email
# Variable can have an underscore or any alphanumerica value
$msg = "Hello there."

# echoing to the screen.
write-host -BackgroundColor Red -ForegroundColor white $msg

#Email from addres
$email = "mason.tripp@mymail.champlain.edu"

# to address
$toEmail = "deployer@csi-web"

# Send the email 
Send-MailMessage -From $email -To $toEmail -Subject "A Greeting" -body $msg -SmtpServer 192.168.6.71