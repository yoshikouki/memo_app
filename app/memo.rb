# frozen_string_literal: true

class Memo
  extend ClassMethod

  attr_accessor :title, :text, :formatted_text, :id

  def initialize(title: '', text: '', id: nil)
    @id = id
    @title = title
    @text = text
    @formatted_text = split_text_with_line_break
  end

  def exist?
    !!self.class.find(@id)
  end

  def create
    self.class.create(self)
  end

  def update(title: '', text: '')
    self.class.update(@id, title, text)
  end

  def destroy
    self.class.destroy(self)
  end

  private

  def split_text_with_line_break
    @text.split(/[\n|\r\n|\r]/)
  end
end
