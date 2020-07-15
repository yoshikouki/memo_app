# frozen_string_literal: true

module Memo
  class Accessor
    attr_reader :title, :path

    def initialize(request_path)
      @title = request_path.slice(/[\w-]+/)
      @path = "./data/#{@title}"
    end

    def file_exist?(path = @path)
      File.exist?(path)
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

    def self.all_content
      Dir.open('./data') do |d|
        d.children.map { |title| Content.new(title) }
      end
    end
  end
end
