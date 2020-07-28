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

  def update(update_memo)
    memo = self_on_record
    self.class.update(memo, update_memo)
  end

  def destroy
    memo = self_on_record
    self.class.destroy(memo)
  end

  private

  def split_text_with_line_break
    @text.split(/[\n|\r\n|\r]/)
  end

  def self_on_record
    record = self.class.find_by_title(title)
    @id = record.id
    record
  end
end
