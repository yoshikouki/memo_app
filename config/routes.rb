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
  memo.create(title: params['title'], text: params['content'])
  redirect "/#{memo.title}"
end

# show
get '/:path' do
  memo = Memo::Validation.new(request.path)
  if memo.valid?
    @memo_title = memo.title
    @title = "Show #{@memo_title} | Memo App"
    @memo = memo.load_content
    haml :show
  else
    redirect '/'
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
    attr_accessor :title, :text, :text_array

    def initialize(title = '')
      return if title.empty?

      @title = title
      @text = load_text
      @text_array = convert_text_to_array
    end

    def load_text
      File.read("./data/#{@title}")
    end

    def convert_text_to_array
      @text.split(/[\n|\r\n|\r]/)
    end

    def create(title:, content:)
      @title = title
      @text = content
      save
    end

    def save
      File.open("./data/#{@title}", 'w') do |f|
        f.print @text
      end
    end
  end

  class Validation
    attr_reader :title, :path

    def initialize(request_path)
      @title = request_path.slice(/[\w-]+/)
      @path = "./data#{request_path}"
    end

    def valid?
      !Dir.glob(@path).empty?
    end

    def load_content
      Content.new(@title)
    end
  end
end
