#!/bin/sh

gem install bundler
bundle install --path vendor/bundle
itamae local recipe.rb
