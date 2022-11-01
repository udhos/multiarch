# STEP 1 build executable binary

#FROM golang:alpine as builder
FROM golang:1.19.3-alpine3.16 as builder

# Create appuser on builder image
RUN adduser -D -g '' appuser

COPY app/* /tmp/app/
COPY go.mod /tmp/app
WORKDIR /tmp/app/

#get dependancies
RUN go mod tidy

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

#build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d/) go build -o /go/bin/app

# STEP 2 build a small image

# start from scratch
FROM scratch

# copy appuser from builder image
COPY --from=builder /etc/passwd /etc/passwd

# Copy our static executable
COPY --from=builder /go/bin/app /go/bin/app

USER appuser

ENTRYPOINT ["/go/bin/app"]
