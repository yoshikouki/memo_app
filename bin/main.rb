#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib/', __dir__))

Dir.mkdir('data') unless File.exist?('./data')

# Sinatra
require 'sinatra'
# Sinatra のオートリロードを実装
require 'sinatra/reloader'

require_relative '../config/routes'
