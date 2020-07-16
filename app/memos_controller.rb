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
  @memo = Memo.find_by_title(convert_path_to_title)
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
  @memo = fetch_memo(request.path)
  @title = "Edit #{@memo.title} | Memo App"
  haml :edit
end

# update
put '/:path' do
  memo = fetch_memo(request.path)
  new_memo = Memo::Content.new(params['title'])
  memo.update(new_memo.title, params['text']) if @validation.validate_update(memo, new_memo)
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

  def convert_param_to_contents
    params.map do |key, value|
      [key.to_sym, value]
    end.to_h
  end

  def require_memo_existed
    redirect '/' unless @memo.exist?
  end

  def require_unique_title
    redirect '/' if @memo.exist?
  end
end
