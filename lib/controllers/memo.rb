# frozen_string_literal: true

require 'controllers/template'

class Memo
  def index
    Template.new.index
  end
end
