#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

export GO111MODULE=on
export GOPATH=/gopath
export GOROOT=/goroot
export PATH="$PATH:$GOROOT/bin"

BUILD_DEPS=(git python curl)

apt-get update
apt-get -y install "${BUILD_DEPS[@]}"
rm -rf /var/lib/apt/lists/*

GO_FILENAME="go${GO_VERSION}.linux-amd64.tar.gz"

cd /tmp
curl -fsSLO "https://dl.google.com/go/${GO_FILENAME}"
echo "${GO_SHA256SUM} ${GO_FILENAME}" | sha256sum -c
tar xzf "$GO_FILENAME"
mv go "$GOROOT"
rm "$GO_FILENAME"


REF="v${INFLUXDB_VERSION}"
PKG="github.com/influxdata/influxdb@${REF}"

go get "$PKG"

#git checkout "$REF"
#python build.py -o /usr/local/bin

cd /

rm -r "$GOPATH" "$GOROOT"

apt-get -y remove "${BUILD_DEPS[@]}"
apt-get -y autoremove

which influx
