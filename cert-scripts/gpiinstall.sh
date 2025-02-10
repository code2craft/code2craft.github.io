#!/bin/sh


# Required certutil tool for script to work

sudo apt-get --yes install libnss3-tools


# Create .pem certificate and import it into the cert8.db and cert9.db certificate stores used by browsers.

cat <<END >SSL_Certificate.pem
-----BEGIN CERTIFICATE-----
MIIDhTCCAm2gAwIBAgIJAMYySQBRmy2uMA0GCSqGSIb3DQEBCwUAMFkxCzAJBgNV
BAYTAlVTMQswCQYDVQQIDAJQQTEQMA4GA1UEBwwHRXBocmF0YTEUMBIGA1UECgwL
VGhpcnRlZW5UZW4xFTATBgNVBAMMDDE5Mi4xNjguMy4xMDAeFw0yMjA3MjkxNDI2
MTlaFw0zMjA2MDYxNDI2MTlaMFkxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJQQTEQ
MA4GA1UEBwwHRXBocmF0YTEUMBIGA1UECgwLVGhpcnRlZW5UZW4xFTATBgNVBAMM
DDE5Mi4xNjguMy4xMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMRs
HWOPHtUij22zkHmHICYS91GYZZHIiNNurBpHfL+kj5ZKDFGfobHH//ycD6bjKBYS
alit/UU42Tbc2sCX9MTtCgjLD8QZopJsHRdirm92RkJEy9iDyVRGiTKPvIY+Cu7Y
9YEH63JqQy0L9MOCG+rZiLyjz6bIYg9kr0UvXgFJoSEFb4X2VKWsCseee9vkwcc/
IXhcrRaMmXP5D84Mz7KZy7KY1Uzpsb0JvlP6ZnXpz2iNexX0L616yAIsk7jupIRD
GvKPEM11iA20FqvBT6ljaFOhgoSepX5m3qp83503jD0jncaOTEaj9ERNMFDYoEsF
qWLM2XpwJBO/fXgxj7ECAwEAAaNQME4wHQYDVR0OBBYEFDKVCEXPCqSSySzrtkTR
om6tCn8NMB8GA1UdIwQYMBaAFDKVCEXPCqSSySzrtkTRom6tCn8NMAwGA1UdEwQF
MAMBAf8wDQYJKoZIhvcNAQELBQADggEBAGjgak8Go4aB0ERSi4LglDRnX6QC+sVU
35+F7f225sOkSca3GnVbcEEaaMRiGM7K1WNrTQ/I7W1PHXOFacEGWQVa/RcRw+Hq
cPIr4i9cNqezMYg0IGBCBR5xtDv/xaOcsEkamNGH8ygI3+OWQNpC9o9IAX6GzQX+
I//x/TsIX7jsywmmsIUL59mkrKaHEqzPQXAh0yr5B5w3us0pOGlrVh4LxoVowyqi
1JNJJfi6z4GqIyY0Gx0xKa0q/+QqWnD4tekoBNSzYvQ89SXpv7Llgczc+FvwVvwB
08G7/w8kRKarivQt4uEY20iQ4Ou89jZOxkF5otopr4RRD/E7fdqAUgc=
-----END CERTIFICATE-----
END

certfile="SSL_Certificate.pem"
certname="The Security Appliance"


# Most browsers use the NSS cert9.db store in the ${HOME}/.pki/nssdb folder. However, this directory is not created until after a browser's first run, meaning the import commands below find no matches until after first run.
# This section checks for the existance of directories used by common browsers to store their cert.db file and--if needed--launches the browser to create the .db file. The browser is then killed as it is no longer needed.
# Using pkill here because Brave and Chrome display a "Default Browser" message on first launch and don't die using -TERM.

brave_install="/opt/brave.com"
brave_config="${HOME}/.config/BraveSoftware"
chrome_install="/opt/google"
chrome_config="${HOME}/.config/google-chrome"
firefox_install="/lib/firefox"
firefox_config="${HOME}/.mozilla/firefox"

if [ -d "$brave_install" ] && [ ! -d "$brave_config" ];
then
  brave-browser &
  sleep 5; pkill brave
  sleep 5; pkill brave-browser
fi

if [ -d "$chrome_install" ] && [ ! -d "$chrome_config" ];
then
  google-chrome &
  sleep 5; pkill chrome
  sleep 5; pkill google-chrome
fi

if [ -d "$firefox_install" ] && [ ! -d "$firefox_config" ];
then
  firefox &
  sleep 5; kill -TERM $!
fi

# For cert8 (legacy - DBM)
for certDB in $(find ~/ -name "cert8.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
done


# For cert9 (SQL)
for certDB in $(find ~/ -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
done


# Move certificate to system path and refresh root store so new certificate is trusted by system utilities like curl and get.
# Browsers require a .pem certificate (used above), but the OS wants a .crt certificate. Both cert types are .PEM encoded,
# so the "mv" command is simply changing the file extension during the move.

certpath="/usr/local/share/ca-certificates/drawbridge"

sudo mkdir -p $certpath
sudo mv $certfile $certpath/SSL_Certificate.crt

sudo update-ca-certificates
