#!/bin/sh
echo "go unit test"
set -x
ls -lrt
go get -d -v golang.org/x/net/html
go get -u github.com/jstemmer/go-junit-report

mkdir ./report
chmod 777 ./report
ls -lrt
go test -v 2>&1 > tmp
status=$?
$GOPATH/bin/go-junit-report < tmp > ./report/index.xml
cat ./report/index.xml
exit ${status}
