To add new trusted hosts for SSL use
com.disc_au.web.ssl.InstallCert

Call it 
 - with the current jssecert file in the classes root directory. 
 - passing the hostname or ip address you want to use (AND NO PASSPHRASE)
 
When prompted type "1" and [enter] 
or enter the number of the cert you wish to add to jssecerts

The jssecerts file MUST be in the /jre/security folder of the Java runtime for it to work though. 

If you get an "Alias" related error, switch the "no-ssl-host-verify" to "Y" in the SOAPClient config to prevent hostname verification.
This is usually because a self-signed cert is not correctly formed with Aliases (google it for more info).  