# frozen_string_literal: true

set :haml, format: :html5,
           views: './lib/views'

# index
get '/' do
  @title = 'Memo App'
  @is_index = true
  @contents = Memo::Accessor.all_content
  haml :index
end

# new
get '/new' do
  @title = 'New Memo | Memo App'
  haml :new
end

# create
post '/' do
  access = Memo::Accessor.new(params['title'])
  if access.validate_create
    memo = access.create_content(text: params[:text])
    redirect "/#{memo.title}"
  else
    redirect '/'
  end
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
  if @validation.validate_update(memo, new_memo)
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
    if @validation.file_exist?
      @validation.load_content
    else
      redirect '/'
    end
  end
end

module Memo
end
