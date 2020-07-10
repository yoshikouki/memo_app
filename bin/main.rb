#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib/', __dir__))

require 'sinatra'
require './config/routes'
require 'controllers/memo'
