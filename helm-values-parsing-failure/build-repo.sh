#!/bin/bash

rm -rf $(dirname $0)/build

mkdir -p $(dirname $0)/build/charts

if [ $(uname -s) = "Darwin" ]; then
for chart in $(find ./charts -d 1 -type d ); do
    tar -C ./charts -czf $(dirname $0)/build/charts/$(basename $chart)-$(grep version $chart/Chart.yaml | awk '{ print $2; }').tgz $(basename $chart)
done
else
for chart in $(find ./charts -maxdepth 1 -mindepth 1 -type d); do
    tar -C ./charts -czf $(dirname $0)/build/charts/$(basename $chart)-$(grep version $chart/Chart.yaml | awk '{ print $2; }').tgz $(basename $chart)
done
fi

helm repo index ./build/charts
