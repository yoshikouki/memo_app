# frozen_string_literal: true

module MemoClassMethod
  DB = PG.connect(dbname: 'memo')

  def all
    sql = 'SELECT title, text FROM memo'
    fetch_memo(sql)
  end

  def find_by_title(title)
    sql = 'SELECT * FROM memo WHERE title = $1'
    fetch_memo(sql, title).first
  end

  def create(text:)
    @text = text
    save
  end

  def validate_create
    !file_exist?(@path)
  end

  def validate_update(memo, new_memo)
    new_title = new_memo.title
    !!(memo.title == new_title || !file_exist?("./data/#{new_title}"))
  end

  private

  def fetch_memo(sql, values_array = [])
    values_array = [values_array] if values_array.class != Array
    DB.exec(sql, values_array) do |result|
      result.map do |record|
        Content.new(record['title'], record['text'])
      end
    end
  end
end
