#!/bin/sh


# Required certutil tool for script to work

sudo apt-get --yes install libnss3-tools


# Create .pem certificate and import it into the cert8.db and cert9.db certificate stores used by browsers.

cat <<END >SSL_Certificate.pem
-----BEGIN CERTIFICATE-----
MIIGHjCCBIagAwIBAgIJAMxiw6IFMWifMA0GCSqGSIb3DQEBCwUAMIG6MQswCQYD
VQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTETMBEGA1UEBxMKUGl0dHNncm92
ZTEaMBgGA1UEChMRVGhpbmt3ZWxsIERlc2lnbnMxEzARBgNVBAsTClRoZSBGb3Jl
c3QxHzAdBgNVBAMTFlRoZSBTZWN1cml0eSBBcHBsaWFuY2UxLzAtBgkqhkiG9w0B
CQEWIHN1cHBvcnRAdGhlc2VjdXJpdHlhcHBsaWFuY2UuY29tMB4XDTEzMTEyNTIx
MTYyMFoXDTQzMTExODIxMTYyMFowgboxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpO
ZXcgSmVyc2V5MRMwEQYDVQQHEwpQaXR0c2dyb3ZlMRowGAYDVQQKExFUaGlua3dl
bGwgRGVzaWduczETMBEGA1UECxMKVGhlIEZvcmVzdDEfMB0GA1UEAxMWVGhlIFNl
Y3VyaXR5IEFwcGxpYW5jZTEvMC0GCSqGSIb3DQEJARYgc3VwcG9ydEB0aGVzZWN1
cml0eWFwcGxpYW5jZS5jb20wggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIB
gQDCe/X9WWXjUWbFsg/7UjgKv5dbcUVa/kCN2nJ3780CM0xnVwKsO70m/FK9Bvrr
PwfVeqkfOJAvFtv++l9QtZTMsH9sxHsQe+nEZrSz4XHnlV7L+0w+WJUGyazyOk/3
jxp4ghmMaMYTUizCQ5RQTa4eFVxS1pVnF2vDA5VCdxJh/gjLKEoPvMozgWXvE8zB
P8dxQrhfXDaqfRcBqP1HB3PgXAqRXhd0V/+htqFtm6+gTKpiiyIkiX82zzVBXTSL
zCnE/9RzAwby2/xWw93RTIf5W3COtLFe02TMh3ZC0UCDh8ADwqnF9SQqaEstkbfL
1BMJYbh4cnWklRfKHNhGxyFG4NkbvNKfZqR+BSbLpxkd/HpKe1jaxNniwtw5k/3Y
/UrvLHRFc5xpqPBXSRmDT1pMT5EwBhVmWg2MtkA8RzP8QrJfhp2ypn+rCrrxaE+a
YfMzLSWSAwQnxM1j06ay0eTZjCNBqTWOj/suNYW1uVPkeQF0D98GhO/+G4Ug9PWY
PSsCAwEAAaOCASMwggEfMB0GA1UdDgQWBBSKUj2JPUXDhsXmXHsrDYEaxdUqwDCB
7wYDVR0jBIHnMIHkgBSKUj2JPUXDhsXmXHsrDYEaxdUqwKGBwKSBvTCBujELMAkG
A1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxEzARBgNVBAcTClBpdHRzZ3Jv
dmUxGjAYBgNVBAoTEVRoaW5rd2VsbCBEZXNpZ25zMRMwEQYDVQQLEwpUaGUgRm9y
ZXN0MR8wHQYDVQQDExZUaGUgU2VjdXJpdHkgQXBwbGlhbmNlMS8wLQYJKoZIhvcN
AQkBFiBzdXBwb3J0QHRoZXNlY3VyaXR5YXBwbGlhbmNlLmNvbYIJAMxiw6IFMWif
MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggGBAIdvOf5zhjcUTjPkotM1
fWr44bBFwwxn2ZsHBlw1UciRUUZUb/zoxr3Ylxh/jvMspWCIKUkIiCTTA7d+I+h4
b4RKbYCr6Y6VKMiK5nr5lk+XNSZyydIHslhY1uEdU82zYxz2cyMw+RqnCBPwQgxq
EeyZbQfK2NrL+75gAxa/sPae2+Y5OSXSQPWgspLngIFoWSFATx0eWka5yZMkYdyf
1m+1EJGUZmvNplXo6GEJro8E+U3o909/qyiXC9N/dJS3QaJqCWhvFGCavEDIsaq6
sKrE0z/0U+7IqZ2NSmtGDt4KDrjw5eGtDYNwMSdVI403nWva4KOFxKUMK03sBzvc
Ab5Blfc/aFF/hFJ8cCrCCODsZRf0EnoeyFv1e0FNoR+57sGhVGQUvDsw0p5RfLav
TUpPsUfbgSWLTnEGwJbJWHXPuebudu61BCnBwchmdTFYuf8zsViT34XYOvmjtU5u
HW/CxtJd6ACG6fWDOb7nDL3gZJw7UxxBWsueiiapupkJRQ==
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
