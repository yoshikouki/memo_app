# frozen_string_literal: true

require 'haml'

set :haml, format: :html5,
           views: './lib/views'

get '/' do
  @title = 'Memo App'
  @is_index = true
  Dir.open('./data') do |d|
    @files = d.children
  end
  haml :index
end

get '/new' do
  @title = 'New Memo'
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
