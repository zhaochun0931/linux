apt update
apt install -y nodejs 


node app.js


openssl s_client -connect localhost:443
openssl s_client -connect localhost:443 -tls1_2

openssl s_client -connect localhost:443 -showcerts
openssl s_client -connect localhost:443 -showcerts -servername server.com


openssl s_client -connect localhost:443 -showcerts -brief

