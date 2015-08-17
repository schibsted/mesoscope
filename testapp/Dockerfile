# docker build -t mesoscope/testapp .

FROM golang

ADD main.go /go/src/localhost/testapp/

WORKDIR /go/src/localhost/testapp/

RUN go install

EXPOSE 8001

ENTRYPOINT ["testapp"]
