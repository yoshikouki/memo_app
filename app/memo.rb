# frozen_string_literal: true

class Memo
  extend MemoClassMethod

  attr_accessor :title, :text, :text_array, :id

  def initialize(title: '', text: '', id: nil)
    return if title.empty?

    @id = id
    @title = title
    @text = text
    @text_array = convert_text_to_array
  end

  def exist?
    !!self.class.find_by_title(@title)
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

  def convert_text_to_array
    @text.split(/[\n|\r\n|\r]/)
  end

  def self_on_record
    record = self.class.find_by_title(title)
    @id = record.id
    record
  end
end
