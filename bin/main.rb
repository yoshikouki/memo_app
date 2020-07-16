#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../app/', __dir__))

# Sinatra
require 'sinatra'
# Sinatra のオートリロードを実装
require 'sinatra/reloader'

# データベースはPostgreSQL
require 'pg'

require 'haml'
require 'memo/memo_class_method'
require 'memo'
require 'memos_controller'
