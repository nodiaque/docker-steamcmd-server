#!/bin/bash

cd "$(dirname "$0")"

./R5/Binaries/Linux/WindroseServer-Linux-Shipping -log &

cd -