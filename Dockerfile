FROM quay.io/projectquay/golang AS builder

WORKDIR /
COPY . .
RUN make builder

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /ets/ssl/certs/
ENTRYPOINT [ "./kbot", "start" ]