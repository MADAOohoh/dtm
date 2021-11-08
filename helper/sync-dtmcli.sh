#! /bin/bash
set -x
ver=$1
if [ x$ver == x ]; then
  echo please specify you version like vx.x.x;
  exit 1;
fi

if [ ${ver:0:1} != v ]; then
  echo please specify you version like vx.x.x;
  exit 1;
fi

cd ../dtmcli
cp -rf ../dtm/dtmcli/* ./
rm -f *_test.go
sed -i '' -e 's/yedf\/dtm\//yedf\//g' *.go
go mod tidy
go build || exit 1
git add .
git commit -m"update from dtm to version $ver"
git push
git tag $ver
git push --tags

cd ../dtmcli-go-sample
go get -u github.com/yedf/dtmcli@$ver
go mod tidy
go build || exit 1
git add .
git commit -m"update from dtm to version $ver"
git push
git tag $ver
git push --tags


cd ../dtmgrpc
rm -rf *.go dtmgimp
cp -r ../dtm/dtmgrpc/* ./
go get -u github.com/yedf/dtmcli@$ver
sed -i '' -e 's/yedf\/dtm\//yedf\//g' *.go
sed -i '' -e 's/yedf\/dtm\//yedf\//g' dtmgimp/*.go dtmgimp/*.proto
rm -rf *_test.go
go mod tidy
go build || exit 1
git add .
git commit -m"update from dtm to version $ver"
git push
git tag $ver
git push --tags

cd ../dtmgrpc-go-sample
go get -u github.com/yedf/dtmcli@$ver
go get -u github.com/yedf/dtmgrpc@$ver
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative busi/*.proto || exit 1
go build || exit 1
git add .
git commit -m"update from dtm to version $ver"
git push