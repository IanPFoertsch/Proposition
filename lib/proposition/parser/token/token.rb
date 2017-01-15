module Proposition
  module Parser
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

    class Atom < Token
    end

    class Operator < Token
    end

    class NAryOperator < Operator
    end

    class Parenthesis < Token
    end

    class Terminal < Token
    end

    class UnaryOperator < Operator
    end
  end
end
