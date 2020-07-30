# frozen_string_literal: true

set :haml, format: :html5,
           views: './app/views'

# index
get '/' do
  @title = 'Memo App'
  @is_index = true
  @memos = Memo.all

  haml :index
end

# new
get '/new' do
  @title = 'New Memo | Memo App'
  haml :new
end

# show
get '/:id' do
  load_memo
  require_memo_existed

  @title = "Show #{@memo.title} | Memo App"
  haml :show
end

# create
post '/' do
  @memo = Memo.new(**contents_with_symbolize_keys)
  @memo.create

  redirect "/#{@memo.id}"
end

# edit
get '/:path/edit' do
  load_memo
  require_memo_existed

  @title = "Edit #{@memo.title} | Memo App"
  haml :edit
end

# update
put '/:path' do
  load_memo
  require_memo_existed
  @memo.update(**contents_with_symbolize_keys)

  redirect "/#{@memo.id}"
end

# destroy
delete '/:path' do
  load_memo
  require_memo_existed
  @memo.destroy

  redirect '/'
end

helpers do
  def load_memo
    @memo = Memo.find(convert_path_to_id)
  end

  def convert_path_to_id
    request.path.slice(/[\w-]+/)
  end

  def contents_with_symbolize_keys
    { title: params['title'], text: params['text'] }
  end

  def require_memo_existed
    redirect '/' unless @memo.exist?
  end
end
