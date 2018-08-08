PACKAGE ?= .
MODE ?= Debug

all: clean build

build:
	(cd cmaki_identifier && npm install --unsafe-perm)
	(cd cmaki_generator && ./build ${PACKAGE} -v)

clean:
	(cd cmaki_identifier && rm -Rf bin rm -Rf artifacts)

