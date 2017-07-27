#!/bin/sh

yum install -y ruby-devel gcc-c++
gem install bundler io-console itamae
bundle install --path vendor/bundle
itamae local recipe.rb
service nginx restart
