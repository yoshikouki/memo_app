# frozen_string_literal: true

module ClassMethod
  DB = PG.connect(dbname: 'memo')

  def all
    sql = 'SELECT * FROM memo;'
    fetch_memo(sql)
  end

  def find(id)
    sql = 'SELECT * FROM memo WHERE id = $1;'
    fetch_memo(sql, id).first
  end

  def create(memo)
    sql = 'INSERT INTO memo (title, text) VALUES ($1, $2);'
    values_array = [memo.title, memo.text]
    DB.exec(sql, values_array)
  end

  def update(id, title, text)
    sql = 'UPDATE memo SET title = $1, text = $2 WHERE id = $3;'
    values_array = [title, text, id]
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
