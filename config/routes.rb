# frozen_string_literal: true

require 'haml'

set :haml, format: :html5,
           views: './views'

get '/' do
  @title = 'これはタイトルです。'
  @is_index = true
  haml :index
end

get '/new' do
  @title = 'New Memo'
  @subtitle = 'これはサブタイトルです。'
  haml :new
end

get '/:id' do
  @title = 'Show Memo'
  haml :show
end

get '/:id/edit' do
  @title = 'Edit Memo'
  haml :edit
end
