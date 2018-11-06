FROM golang

ARG app_env
ENV APP_ENV $app_env

COPY . /go/src/github.com/Timrael/autocomplete/go_app
WORKDIR /go/src/github.com/Timrael/autocomplete/go_app

RUN go get ./
RUN go build

CMD if [ ${APP_ENV} = production ]; \
	then \
	go_app; \
	else \
	go get github.com/pilu/fresh && \
	fresh; \
	fi
