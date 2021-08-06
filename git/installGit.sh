#!/bin/bash
#Author cz
#Date 2020.9.5

gitBaseDir="/ops/app/git-2.11.0"

start(){
  echo "tar -xf /ops/inst/git-2.11.0.tar.gz -C /ops/app"
  tar -xf /ops/inst/git-2.11.0.tar.gz -C /ops/app
  echo "yum install libcurl-devel -y"
  yum install libcurl-devel -y
  echo "yum remove git"
  yum remove git
  echo "yum install  autoconf automake libtool -y"
  yum install  autoconf automake libtool -y
  echo "yum install zlib -y"
  yum install zlib -y
  echo "yum install zlib-devel -y"
  yum install zlib-devel -y
  echo "install perl-ExtUtils-MakeMaker package -y"
  yum install perl-ExtUtils-MakeMaker package -y
  echo "cd ${gitBaseDir}"
  cd ${gitBaseDir}
  echo "./configure --prefix=${gitBaseDir} --with-iconv --with-curl --with-expat=/usr/local/lib"
  ./configure --prefix=${gitBaseDir} --with-iconv --with-curl --with-expat=/usr/local/lib
  echo "make && make install"
  make && make install
  echo "export PATH=$PATH:${gitBaseDir}/bin" >> /etc/bashrc
  echo "source /etc/bashrc"
  source /etc/bashrc
  git --version
}

start