#!/usr/bin/env ruby
# frozen_string_literal: true

lib_path = File.expand_path('../lib/', __dir__)
$LOAD_PATH.unshift(lib_path)

Dir.mkdir('data') unless File.exist?('./data')

# Sinatra
require 'sinatra'
# Sinatra のオートリロードを実装
require 'sinatra/reloader'
# /lib 内ののオートリロードを実装
require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir(lib_path)
loader.setup

require_relative '../config/routes'
