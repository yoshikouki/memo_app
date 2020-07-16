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

# show
get '/:path' do
  access = Memo::Accessor.new(convert_path_to_title)
  require_memo_existed(access)

  @memo = access.to_memo
  @title = "Show #{@memo.title} | Memo App"
  haml :show
end

# new
get '/new' do
  @title = 'New Memo | Memo App'
  haml :new
end

# create
post '/' do
  access = Memo::Accessor.new(params['title'])
  redirect '/' and return if access.validate_create

  memo = access.create_content(text: params[:text])
  redirect "/#{memo.title}"
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
  def convert_path_to_title
    request.path.slice(/[\w-]+/)
  end

  def require_memo_existed(access)
    redirect '/' unless access.exist_memo?
  end
end

module Memo
end
