# frozen_string_literal: true

class Memo
  extend MemoClassMethod

  attr_accessor :title, :text, :text_array, :record

  def initialize(title: '', text: '')
    return if title.empty?

    @title = title
    @text = text
    @text_array = convert_text_to_array
  end

  def exist?
    !!self.class.find_by_title(@title)
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

  def destroy
    File.delete(@path)
  end

  private

  def convert_text_to_array
    @text.split(/[\n|\r\n|\r]/)
  end

  def save
    File.open(@path, 'w') { |f| f.print @text }
    self
  end
end
