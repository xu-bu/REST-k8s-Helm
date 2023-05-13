# use alpine container to pull in root certs
FROM alpine:3.15 as root-certs
# add non-root user 'app' to run container for security
RUN apk add -U --no-cache ca-certificates
RUN addgroup -g 1001 app
RUN adduser app -u 1001 -D -G app /home/app

# use golang container to build app
FROM golang:1.17 as builder
WORKDIR /youtube-api-files
COPY --from=root-certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -mod=vendor -o ./youtube-stats ./app/./...

# scratch is an empty container to build your own container
FROM alpine:3.17 as final
COPY --from=root-certs /etc/passwd /etc/passwd
COPY --from=root-certs /etc/group /etc/group
COPY --chown=1001:1001 --from=root-certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --chown=1001:1001 --from=builder /youtube-api-files/youtube-stats /youtube-stats
USER app
ENTRYPOINT ["/youtube-stats"]
# CMD ["/bin/sh", "-c", "while true; do sleep 1; done"]