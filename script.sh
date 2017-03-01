#!/bin/bash
dir="/opt/deployment"
dir_old="/opt/deployment/old"
dir_cur="/opt/deployment/curr"
dir_dist="/opt/deployment/dist"

curl -u admin:admin123 -O http://nexus/repository/deplyment-jboss/12-index.tar.gz
echo $VER_ART



if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $dir_old ]]; then
    mkdir $dir_old
fi

if [[ ! -e $dir_cur ]]; then
    mkdir $dir_cur
fi

if [[ ! -e $dir_dist ]]; then
    mkdir $dir_dist
else
    rm -f $dir_dist/*
fi
