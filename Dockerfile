FROM golang:1.20-alpine AS builder
RUN apk update
RUN apk add git
WORKDIR /roadrunner
RUN git clone https://github.com/roadrunner-server/roadrunner.git
WORKDIR /roadrunner/plugins
COPY ./attr ./attr
WORKDIR /roadrunner/roadrunner
RUN sed '/^go 1\.20/a replace github.com\/dwgebler\/attr => ..\/plugins\/attr' -i ./go.mod
RUN sed $'/^import (/a \t"github.com/dwgebler/attr/tlsattr"' -i ./container/plugins.go
RUN sed '/return \[\]any{/a \&tlsattr\.Plugin{},' -i ./container/plugins.go
RUN go get github.com/dwgebler/attr && go mod download && go mod tidy && CGO_ENABLED=0 go build -trimpath -ldflags "-s" -o rr cmd/rr/main.go
