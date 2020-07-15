# frozen_string_literal: true

require 'memo/content'

module Memo
  class Accessor
    attr_reader :title, :path

    def initialize(request_path)
      @title = request_path.slice(/[\w-]+/)
      @path = "./data/#{@title}"
    end

    def exit?(path = @path)
      File.exist?(path)
    end

    def validate_new_content(text:)
      return false if exit?(@path)

      @text = text
      self
    end

    def validate_update_content(memo, new_memo)
      new_title = new_memo.title
      !!(memo.title == new_title || !exit?("./data/#{new_title}"))
    end

    def create_content
      Content.new(@title).create(text: @text)
    end

    def load_content
      Content.new(@title)
    end
  end
end
