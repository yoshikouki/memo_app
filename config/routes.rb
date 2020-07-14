# frozen_string_literal: true

require 'haml'

set :haml, format: :html5,
           views: './lib/views'

helpers do
  def fetch_memo(request_path)
    memo = Memo::Validation.new(request_path)
    if memo.valid?
      memo.load_content
    else
      redirect '/'
      return
    end
  end
end

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
  title = params['title']
  memo = Memo::Validation.new(title)
  memo.create_content(title: title, text: params['text'])
  redirect "/#{memo.title}"
end

# show
get '/:path' do
  @memo = fetch_memo(request.path)
  @title = "Show #{@memo.title} | Memo App"
  haml :show
end

# edit
get '/:path/edit' do
  # require 'byebug' ; byebug
  @memo = fetch_memo(request.path)
  @title = "Edit #{@memo.title} | Memo App"
  haml :edit
end

# update
patch '/:path' do
  memo = fetch_memo(request.path)
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

    def create(title:, text:)
      @title = title
      @text = text
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
      @path = "./data/#{@title}"
    end

    def valid?
      !Dir.glob(@path).empty?
    end

    def create_content(title:, text:)
      Content.new.create(title: title, text: text)
    end

    def load_content
      Content.new(@title)
    end
  end
end
