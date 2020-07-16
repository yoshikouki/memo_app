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
require 'memos_controller'
require 'memo'
require 'memo/memo_class_method'
