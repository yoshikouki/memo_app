# frozen_string_literal: true

require 'haml'

get '/' do
  @title = 'これはタイトルです。'
  @subtitle = 'これはサブタイトルです。'
  haml :index, :format =>  :html5
end
