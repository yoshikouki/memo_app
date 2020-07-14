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
  title = params['title']
  validation = Memo::Validation.new(title)
  validation.create_content if validation.validate_new_content(title: title, text: params[:text])
  redirect "/#{validation.title}"
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
put '/:path' do
  memo = fetch_memo(request.path)
  @validation.update_content(memo.title) if @validation.validate_update_content(memo, params)
  redirect "/#{memo.title}"
end

# destroy
delete '/:path' do
  if memo = fetch_memo(request.path)
    memo.destroy
  end
  redirect '/'
end

helpers do
  def fetch_memo(request_path)
    @validation = Memo::Validation.new(request_path)
    if @validation.exit?
      @validation.load_content
    else
      redirect '/'
    end
  end
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
      @title ||= title
      @text = text
      save
    end

    def update(title:, text:)
      if @title != title
        File.rename("./data/#{@title}", "./data/#{title}")
      end
      @title = title
      @text = text
      save
    end

    def save
      File.open("./data/#{@title}", 'w') do |f|
        f.print @text
      end
    end

    def destroy
      File.delete("./data/#{@title}")
    end
  end

  class Validation
    attr_reader :title, :path

    def initialize(request_path)
      @title = request_path.slice(/[\w-]+/)
      @path = "./data/#{@title}"
    end

    def exit?(path = @path)
      !Dir.glob(path).empty?
    end

    def validate_new_content(title:, text:)
      return false if exit?("./data/#{title}")

      @title = title
      @text = text
      self
    end

    def validate_update_content(memo, new_content)
      new_title = new_content[:title]
      return false if memo.title != new_title && exit?("./data/#{new_title}")

      @title = new_title
      @text = new_content[:text]
      self
    end

    def create_content
      Content.new.create(title: @title, text: @text)
    end

    def load_content
      Content.new(@title)
    end

    def update_content(old_title)
      Content.new(old_title).update(title: @title, text: @text)
    end
  end
end
