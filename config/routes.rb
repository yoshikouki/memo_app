# frozen_string_literal: true

require 'haml'

set :haml, format: :html5,
           views: './views'

get '/' do
  @title = 'これはタイトルです。'
  @subtitle = 'これはサブタイトルです。'
  haml :index
end
