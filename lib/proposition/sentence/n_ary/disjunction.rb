require_relative "n_ary_sentence"
module Proposition
  class Disjunction < NArySentence
    def operator
      Logic::OR
    end
  end
end
