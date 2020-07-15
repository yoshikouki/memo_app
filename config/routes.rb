# frozen_string_literal: true

require 'haml'
require 'accessor'
require 'content'

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
  validation = Memo::Accessor.new(params['title'])
  memo = validation.create_content if validation.validate_new_content(text: params[:text])
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
  @memo = fetch_memo(request.path)
  @title = "Edit #{@memo.title} | Memo App"
  haml :edit
end

# update
put '/:path' do
  memo = fetch_memo(request.path)
  new_memo = Memo::Content.new(params['title'])
  if @validation.validate_update_content(memo, new_memo)
    memo.update(new_memo.title, params['text'])
  end
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
    @validation = Memo::Accessor.new(request_path)
    if @validation.exit?
      @validation.load_content
    else
      redirect '/'
    end
  end
end
