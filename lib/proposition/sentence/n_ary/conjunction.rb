require_relative "n_ary_sentence"
module Proposition
  class Conjunction < NArySentence
    def operator
      Logic::AND
    end

    def to_conjunctive_normal_form
      ConjunctiveNormalForm.new(sentences)
    end
  end
end
