module Proposition
  module Parser
    class Lexer

      OPEN_PARENTHESIS = "("
      CLOSE_PARENTHESIS = ")"

      SLASH = "/"
      WHITESPACE = [" ", "\t"]

      TERMINALS = [";", "\n"]

      AND = "and"
      OR = "or"
      XOR = "xor"
      IMPLICATION = "=>"
      BICONDITIONAL = "<=>"
      NOT = "not"

      UNARY_OPERATORS = [NOT]
      N_ARY_OPERATORS = [AND, OR]
      BINARY_OPERATORS = [XOR, IMPLICATION, BICONDITIONAL]

      def initialize(input)
        @token_queue = build_token_queue(input)
      end

      def look_ahead(n) #look ahead into the token queue n tokens
        @token_queue[n] ? @token_queue[n].clone : nil
      end

      def get_next_token
        @token_queue.shift
      end

      private

      def build_token_queue(input)
        #TODO: Clean up this nonsensical looping and initialization
        @characters = input.chars #split by whitespace
        @current = 0
        queue = []

        while @current <= (@characters.length - 1)
          queue.push(next_token)
        end

        queue
      end

      def next_token
        #TODO: consolidate symbol => Token logic to TokenBuilder class
        if current_is_whitespace?
          consume_whitespace
          next_token
        elsif current_is_character?
          string = consume_characters
          if current_is_unary_operator?(string)
            UnaryOperator.new(string)
          elsif current_is_binary_operator?(string)
            BinaryOperator.new(string)
          elsif current_is_n_ary_operator?(string)
            NAryOperator.new(string)
          else
            Atom.new(string)
          end
        elsif current_is_parenthesis?
          return Parenthesis.new(consume_current)
        elsif current_is_terminal?
          Terminal.new(consume_current)
        else
          raise "No rule defined for character #{current_character}"
        end
      end

      def current_is_parenthesis?
        current_character == OPEN_PARENTHESIS || current_character == CLOSE_PARENTHESIS
      end

      def current_is_whitespace?
        WHITESPACE.include?(current_character)
      end

      def current_is_unary_operator?(string)
        UNARY_OPERATORS.include?(string)
      end

      def current_is_n_ary_operator?(string)
        N_ARY_OPERATORS.include?(string)
      end

      def current_is_binary_operator?(string)
        BINARY_OPERATORS.include?(string)
      end

      def current_is_terminal?
        TERMINALS.include?(current_character)
      end

      def current_is_character?
        #matches any alphanumeric
        result = current_character =~ /[A-Za-z_]/
        #if non-alphanumeric, checks for operator symbols such as
        #=> or <=>
        result || current_character =~ /[<=>]/
      end

      def current_is_numeric?
        current_character =~ /[0-9]/
      end

      def consume_characters
        identifier = ""
        while current_is_character? || current_is_numeric?
          identifier += consume_current
        end

        identifier
      end

      def consume_whitespace
        while current_is_whitespace?
          @current += 1
        end
      end

      def consume_current
        character = current_character
        @current += 1

        character
      end

      def current_character
        @characters[@current]
      end
    end
  end
end
