module Proposition
  class Token
    attr_reader :string
    def initialize(string)
      @string = string
    end

    def ==(other)
      #TODO: this logic is shared amongst many classes, consolidate to module
      return false unless other.is_a?(self.class)
      other.string == self.string
    end
  end
end
