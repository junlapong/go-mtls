# mTLS example in Go

## What is mutual TLS (mTLS)?

mTLS, short for Mutual Transport Layer Security, is a form of bi-directional security between two services where the TLS protocol is applied in both directions. The difference between mTLS and the standard form of browser HTTPS is, when you try to access an HTTPS/TLS endpoint, the client attempts to verify the presented certificate from the server, but in mTLS, the verification process is done by both the client and server for the corresponding other side of the connection.

## Generate CA, Server and Client key/certificate 

```
openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 3650 -key ca.key -subj "/C=TH/ST=RB/O=IT Sec/CN=CA" -out ca.crt

openssl req -newkey rsa:4096 -nodes -keyout server.key -subj "/C=TH/ST=RB/O=Dev/CN=localhost" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,DNS:www.example.com,IP.1:127.0.0.1") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```

```
openssl req -text -noout -in server.csr
openssl req -text -noout -verify -in server.csr
openssl x509 -text -noout -in server.crt
```

```
openssl genrsa -out client.key 4096
openssl req -new -key client.key -out client.csr -subj "/C=TH/ST=RB/O=Dev/CN=client"
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -out client.crt -days 365 -sha256 -CAcreateserial
```

## Test

```
go run server/server.go

2021/12/05 23:36:03 listen on https://localhost:8443
2021/12/05 23:38:58 new request
```

```
go run client/client.go

hello world
```

## Notes

- [What is mutual TLS (mTLS)?](https://www.cloudflare.com/learning/access-management/what-is-mutual-tls/)
- [How to MTLS in golang](https://kofo.dev/how-to-mtls-in-golang)
- [Know about SAN Certificate and How to Create With OpenSSL](https://geekflare.com/san-ssl-certificate/)
- [The Most Common OpenSSL Commands](https://www.sslshopper.com/article-most-common-openssl-commands.html)
- [A Tour of TLS](https://youtu.be/yzz3bcnWf7M)
