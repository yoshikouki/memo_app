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
post '/' do
  memo = Memo::Content.new
  memo.create(title: params['title'], content: params['content'])
  redirect "/#{memo.title}"
end

# show
get '/:path' do
  @path = request.path.slice(/[\w-]+/)
  if Dir.glob("./data/#{@path}").empty?
    redirect '/'
  else
    @title = "Show #{@path} | Memo App"
    @memo = Memo::Content.new(@path)
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

module Memo
  class Content
    attr_accessor :title, :content, :content_array

    def initialize(path = '')
      @title = path
      unless path.empty?
        @content = File.read("./data/#{path}")
        @content_array = @content.split(/[\n|\r\n|\r]/)
      end
    end

    def create(title:, content:)
      @title = title
      @content = content
      save
    end

    def save
      File.open("./data/#{@title}", 'w') do |f|
        f.print @content
      end
    end
  end
end
