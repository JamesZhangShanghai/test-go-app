#!/bin/sh
echo "go unit test"
set -x
go mod init goapp
ls -lrt
go get -d -v golang.org/x/net/html
go get -u github.com/jstemmer/go-junit-report

sleep 1800

go test -v 2>&1 > tmp
status=$?
$GOPATH/bin/go-junit-report < tmp > test_output.xml

exit ${status}
