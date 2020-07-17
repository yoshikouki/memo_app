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
get '/:path' do
  load_memo
  require_memo_existed

  @title = "Show #{@memo.title} | Memo App"
  haml :show
end

# create
post '/' do
  contents = convert_param_to_contents
  @memo = Memo.new(**contents)
  require_unique_title
  @memo.create

  redirect "/#{@memo.title}"
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
  update_memo = Memo.new(**convert_param_to_contents)
  require_unique_title(update_memo) if @memo.title != update_memo.title
  @memo.update(update_memo)

  redirect "/#{update_memo.title}"
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
    @memo = Memo.find_by_title(convert_path_to_title)
  end

  def convert_path_to_title
    request.path.slice(/[\w-]+/)
  end

  def convert_param_to_contents
    { title: params['title'], text: params['text'] }
  end

  def require_memo_existed
    redirect '/' unless @memo.exist?
  end

  def require_unique_title(memo = @memo)
    redirect '/' if memo.exist?
  end
end
