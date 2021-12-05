# Example
example:
	@cd certs && \
	rm example.* && \
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -days 3650 \
	  -keyout example.key -out example.crt \
	  -subj "/C=TH/ST=RB/O=Dev/CN=localhost" \
	  -addext 'subjectAltName=DNS:example.com,DNS:www.example.com,IP.1:127.0.0.1' && \
	openssl x509 -noout -text -in example.crt && \
	cd -

# Generating our rootCA file.
ca_crt:
	@cd certs && \
	openssl req -x509 -newkey rsa:4096 -sha256 -nodes -days 3650 \
	  -keyout ca.key -out ca.crt \
	  -subj "/C=TH/ST=RB/O=IT Sec/CN=CA" && \
	cd -

# Generating server key.
server_key:
	@cd certs && \
	openssl genrsa -out server.key 4096 && \
	cd -

# Generate the Certificate Signing Request
# openssl req -text -noout -in certs/server.csr
server_csr:
	@cd certs && \
	openssl req -new -key server.key -out server.csr \
	  -subj "/C=TH/ST=RB/O=Dev/CN=localhost" \
	  -addext "subjectAltName=DNS:example.com,DNS:localhost,IP.1:127.0.0.1" && \
	cd -

# Generating server certificate.
server_crt:
	@cd certs && \
	openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
	  -out server.crt -days 365 -sha256 && \
	cd -

# Generating the client certificate.
client_crt:
	@cd certs && \
	openssl genrsa -out client.key 4096 && \
	openssl req -new -key client.key -out client.csr -subj "/C=TH/ST=RB/O=Dev/CN=client" && \
	openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -out client.crt -days 365 -sha256 -CAcreateserial && \
	rm client.csr && \
	cd -
