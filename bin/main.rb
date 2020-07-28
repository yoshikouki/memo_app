#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib/', __dir__))

# Sinatra
require 'sinatra'
# Sinatra のオートリロードを実装
require 'sinatra/reloader'

require 'haml'
require 'memo'
require 'memo/accessor'
require 'memo/content'
require 'memos_controller'
