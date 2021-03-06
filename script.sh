#!/bin/bash

dir="/opt/deployment"
dir_old="/opt/deployment/old"
dir_cur="/opt/deployment/curr"
dir_dist="/opt/deployment/dist"

VER_ART=$1


curl -u admin:admin123 -o /opt/$VER_ART-index.tar.gz http://nexus/repository/deplyment-jboss/$VER_ART-index.tar.gz 

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
    cp /opt/$VER_ART-index.tar.gz $dir_cur/
else
    if [[ -e $dir_cur/$(($VER_ART-1))-index.tar.gz ]]; then
        cp $dir_cur/$(($VER_ART-1))-index.tar.gz $dir_old/
        rm -f $dir_cur/*
        cp /opt/$VER_ART-index.tar.gz $dir_cur/
    else
        cp /opt/$VER_ART-index.tar.gz $dir_cur/
    fi
fi

if [[ ! -e $dir_dist ]]; then
    mkdir $dir_dist
    cp /opt/$VER_ART-index.tar.gz $dir_dist/
else
    rm -f $dir_dist/*
    cp /opt/$VER_ART-index.tar.gz $dir_dist/
fi

tar xzvf $dir_dist/$VER_ART-index.tar.gz -C /opt/jboss-as-7.1.1.Final/welcome-content/

rm -f /opt/$VER_ART-index.tar.gz

code=`curl -s -I http://jboss | grep HTTP/1.1 | awk {'print $2'}`
if [[ "$code" != "200" ]]; then
    echo "not super code"
    rm -f $dir_cur/*
    rm -f $dir_dist/*
    cp $dir_old/$(($VER_ART-1))-index.tar.gz $dir_cur/
    cp $dir_old/$(($VER_ART-1))-index.tar.gz $dir_dist/
    rm -f $dir_old/*
    curl -u admin:admin123 -o $dir_old/$(($VER_ART-2))-index.tar.gz http://nexus/repository/deplyment-jboss/$(($VER_ART-2))-index.tar.gz
fi
