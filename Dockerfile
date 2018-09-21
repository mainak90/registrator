FROM golang:1.11-alpine3.8 AS builder

RUN apk --no-cache add -t build-deps build-base git curl mercurial ca-certificates

COPY . /go/src/github.com/gliderlabs/registrator

RUN go version

RUN export GOPATH=/go && mkdir -p /go/bin && export PATH=$PATH:/go/bin \
	&& cd /go/src/github.com/gliderlabs/registrator \
	&& go get -d ./...

# fix deprecations
RUN cd $GOPATH/src/github.com/ugorji/go && git checkout 8c0409fcbb70099c748d71f714529204975f6c3f \
    && cd $GOPATH/src/github.com/hashicorp/consul && git checkout v1.0.6

# build registrator
RUN cd /go/src/github.com/gliderlabs/registrator \
    && go build -v -ldflags "-X main.Version=$(cat VERSION)" -o /bin/registrator


FROM alpine:3.8
COPY --from=builder /bin/registrator /bin/registrator
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/bin/registrator"]
