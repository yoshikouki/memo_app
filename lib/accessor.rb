# frozen_string_literal: true

require 'content'

module Memo
  class Accessor
    attr_reader :title, :path

    def initialize(request_path)
      @title = request_path.slice(/[\w-]+/)
      @path = "./data/#{@title}"
    end

    def exit?(path = @path)
      !File.exist?(path)
    end

    def validate_new_content(text:)
      return false if exit?(@path)

      @text = text
      self
    end

    def validate_update_content(memo, new_content)
      new_title = new_content[:title]
      return false if memo.title != new_title && exit?("./data/#{new_title}")

      @title = new_title
      @text = new_content[:text]
      self
    end

    def create_content
      Content.new(@title).create(text: @text)
    end

    def load_content
      Content.new(@title)
    end

    def update_content(old_title)
      Content.new(old_title).update(title: @title, text: @text)
    end
  end
end
