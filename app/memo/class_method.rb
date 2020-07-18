# frozen_string_literal: true

module ClassMethod
  DB = PG.connect(dbname: 'memo')

  def all
    sql = 'SELECT title, text FROM memo;'
    fetch_memo(sql)
  end

  def find_by_title(title)
    sql = 'SELECT * FROM memo WHERE title = $1;'
    fetch_memo(sql, title).first
  end

  def create(memo)
    sql = 'INSERT INTO memo (title, text) VALUES ($1, $2);'
    values_array = [memo.title, memo.text]
    DB.exec(sql, values_array)
  end

  def update(memo, update_memo)
    sql = 'UPDATE memo SET title = $1, text = $2 WHERE id = $3;'
    values_array = [update_memo.title, update_memo.text, memo.id]
    DB.exec(sql, values_array)
  end

  def destroy(memo)
    sql = 'DELETE FROM memo WHERE id = $1;'
    values_array = [memo.id]
    DB.exec(sql, values_array)
  end

  private

  def fetch_memo(sql, values_array = [])
    values_array = [values_array] if values_array.class != Array
    DB.exec(sql, values_array) do |result|
      result.map do |record|
        new(title: record['title'], text: record['text'], id: record['id'])
      end
    end
  end
end
