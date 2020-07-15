# frozen_string_literal: true

module Memo
  class Content
    attr_accessor :title, :text, :text_array

    def initialize(title = '', text = '')
      return if title.empty?

      @title = title
      set_path
      @text = text
      @text_array = convert_text_to_array
    end

    def set_path
      @path = "./data/#{@title}"
    end

    def convert_text_to_array
      @text.split(/[\n|\r\n|\r]/)
    end

    def create(text:)
      @text = text
      save
    end

    def update(new_title, new_text)
      if @title != new_title
        old_path = @path.dup
        @title = new_title
        set_path
        File.rename(old_path, @path)
      end
      @text = new_text
      save
    end

    def save
      File.open(@path, 'w') { |f| f.print @text }
      self
    end

    def destroy
      File.delete(@path)
    end
  end
end
