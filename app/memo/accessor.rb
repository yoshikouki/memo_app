# frozen_string_literal: true

module Memo
  class Accessor
    DB = PG.connect(dbname: 'memo')

    def initialize(title)
      @memo = find_content(title) || nil
      @title = title
    end

    def exist_memo?
      !!@memo
    end

    def to_memo
      @memo
    end

    def validate_create
      !file_exist?(@path)
    end

    def validate_update(memo, new_memo)
      new_title = new_memo.title
      !!(memo.title == new_title || !file_exist?("./data/#{new_title}"))
    end

    def create_content(text:)
      @text = text
      Content.new(@title).create(text: @text)
    end

    def load_content
      Content.new(@title)
    end

    private

    def find_content(title)
      sql = 'SELECT * FROM memo WHERE title = $1'
      self.class.fetch_memo(sql, title).first
    end

    class << self
      def all_content
        sql = 'SELECT title, text FROM memo'
        fetch_memo(sql)
      end

      def fetch_memo(sql, values_array = [])
        values_array = [values_array] if values_array.class != Array
        DB.exec(sql, values_array) do |result|
          result.map do |record|
            Content.new(record['title'], record['text'])
          end
        end
      end
    end
  end
end
