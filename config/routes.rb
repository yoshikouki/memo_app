# frozen_string_literal: true

require 'controllers/memo'

get '/' do
  Memo.new.index
end
