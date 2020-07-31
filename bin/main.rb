#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../app/', __dir__))

require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'pg'

require 'memo/class_method'
require 'memo'
require 'memos_controller'
