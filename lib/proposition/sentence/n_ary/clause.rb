require_relative "disjunction"
require_relative "../atomic_sentence"
module Proposition
  class Clause < Disjunction
    #TODO: Throw exception unless initialized with only Atomic components
  end
end
