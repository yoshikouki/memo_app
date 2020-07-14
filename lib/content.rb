# frozen_string_literal: true

module Memo
  class Content
    attr_accessor :title, :text, :text_array

    def initialize(title = '')
      return if title.empty?

      @path = "./data/#{title}"
      @title = title
      @text = load_text
      @text_array = convert_text_to_array
    end

    def load_text
      File.read(@path)
    end

    def convert_text_to_array
      @text.split(/[\n|\r\n|\r]/)
    end

    def create(title:, text:)
      @title ||= title
      @text = text
      save
    end

    def update(title:, text:)
      File.rename(@path, "./data/#{title}") if @title != title
      @title = title
      @text = text
      save
    end

    def save
      File.open(@path, 'w') { |f| f.print @text }
    end

    def destroy
      File.delete(@path)
    end
  end
end
