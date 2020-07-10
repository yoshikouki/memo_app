# frozen_string_literal: true

get '/' do
  Memo.new.index
end
