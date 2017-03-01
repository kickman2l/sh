#!/bin/bash

dir="/opt/deployment"
dir_old="/opt/deployment/old"
dir_cur="/opt/deployment/curr"
dir_dist="/opt/deployment/dist"

echo $VER_ART
echo ${VER_ART}


curl -u admin:admin123 -o /opt/${VER_ART}-index.tar.gz http://nexus/repository/deplyment-jboss/$VER_ART-index.tar.gz 

if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $dir_old ]]; then
    mkdir $dir_old
else
    rm -f $dir_old/*
    cp $dir_cur/$(($VER_ART-1))-index.tar.gz $dir_old/
fi

if [[ ! -e $dir_cur ]]; then
    mkdir $dir_cur
    cp $WORKSPACE/$VER_ART-index.tar.gz $dir_cur/
else
    if [[ -e $dir_cur/$(($VER_ART-1))-index.tar.gz ]]; then
        cp $dir_cur/$(($VER_ART-1))-index.tar.gz $dir_old/
        rm -f $dir_cur/*
        cp $WORKSPACE/$VER_ART-index.tar.gz $dir_cur/
    else
        cp $WORKSPACE/$VER_ART-index.tar.gz $dir_cur/
    fi
fi

if [[ ! -e $dir_dist ]]; then
    mkdir $dir_dist
    cp $WORKSPACE/$VER_ART-index.tar.gz $dir_dist/
else
    rm -f $dir_dist/*
    cp $WORKSPACE/$VER_ART-index.tar.gz $dir_dist/
fi

tar xzvf $dir_dist/$VER_ART-index.tar.gz -C /opt/jboss-as-7.1.1.Final/welcome-content/

rm -f $WORKSPACE/$VER_ART-index.tar.gz
