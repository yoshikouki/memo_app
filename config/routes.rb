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

get '/:path' do
  @path = request.path
  if Dir.glob("./data/#{@path}").empty?
    redirect '/'
  else
    @title = "Show #{@path}"
    @content = File.read("./data/#{@path}").split(/[\n|\r\n|\r]/)
    haml :show
  end
end

get '/:id/edit' do
  @title = 'Edit Memo'
  haml :edit
end
