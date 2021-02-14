#!/bin/sh
echo "go unit test"
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
sleep 1800
set -x

go get -d -v golang.org/x/net/html
go get -u github.com/jstemmer/go-junit-report
go test -v 2>&1 > tmp
status=$?
$GOPATH/bin/go-junit-report < tmp > test_output.xml

exit ${status}
