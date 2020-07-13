# frozen_string_literal: true

require 'haml'

set :haml, format: :html5,
           views: './lib/views'

# index
get '/' do
  @title = 'Memo App'
  @is_index = true
  Dir.open('./data') do |d|
    @files = d.children
  end
  haml :index
end

# new
get '/new' do
  @title = 'New Memo | Memo App'
  haml :new
end

# create
post '/:path' do
end

# show
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

# edit
get '/:id/edit' do
  @title = 'Edit Memo | Memo App'
  haml :edit
end

# update
patch '/:path' do
end

# destroy
delete '/:path' do
end
