echo "Generating CA..."
openssl req -x509 -new -nodes -keyout ca.key -sha256 -days 1825 -out ca.crt -subj "/C=GB/ST=/L=/O=/OU=/CN=localhost-ca/emailAddress="
echo "Generating key..."
openssl genrsa -out localhost.key -passout pass:foobar  2048
echo "Generating cert..."
openssl req -new -key localhost.key -passin pass:foobar -out localhost.csr -addext "subjectAltName = DNS:localhost" -subj "/C=GB/ST=/L=/O=/OU=/CN=localhost/emailAddress="
cat <<EOT >> localhost.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
EOT
openssl x509 -req -in localhost.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out localhost.crt -days 365 -sha256 -extfile localhost.ext
echo "Generating client key..."
openssl genrsa -out client.key -passout pass:foobar  2048
echo "Generating client cert..."
openssl req -new -sha256 -key client.key -passin pass:foobar -out client.csr -subj "/C=GB/ST=/L=/O=/OU=/CN=user1/emailAddress=user@localhost"
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365 -sha256
openssl pkcs12 -export -out client.p12 -in client.crt -inkey client.key -passin pass:foobar -passout pass:foobar
echo "Done."