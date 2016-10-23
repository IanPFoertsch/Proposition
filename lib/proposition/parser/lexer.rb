module Proposition
  class Lexer

    OPEN_PARENTHESIS = "("
    CLOSE_PARENTHESIS = ")"

    SLASH = "/"
    WHITESPACE = [" ", "\n" "\t"]
    OPERATORS = ["and", "or", "xor", "=>", "<=>"]


    def initialize(input)
      @characters = input.chars #split by whitespace
      @current = 0
    end

    def next_token
      if current_is_whitespace?
        consume_whitespace
        next_token
      elsif current_is_character?
        string = consume_characters
        if is_operator?(string)
          Operator.new(string)
        else
          Atom.new(string)
        end
      elsif current_is_parenthesis?
        return Parenthesis.new(consume_current)
      else
        raise "No rule defined for character #{current}"
      end
    end



    def is_operator?(string)
      OPERATORS.include?(string)
    end

    def consume_characters
      identifier = ""
      while current_is_character? || current_is_numeric?
        identifier += consume_current
      end

      identifier
    end

    def current_is_parenthesis?
      current == OPEN_PARENTHESIS || current == CLOSE_PARENTHESIS
    end

    def current_is_whitespace?
      WHITESPACE.include?(current)
    end

    def consume_whitespace
      while current_is_whitespace?
        @current += 1
      end
    end

    def consume_current
      character = current
      @current += 1

      character
    end

    def identifier?
      character? || numeric?
    end

    def current_is_character?
      #matches any alphanumeric
      result = current =~ /[A-Za-z_]/
      #if non-alphanumeric, checks for operator symbols such as
      #=> or <=>
      result || current =~ /[<=>]/
    end

    def current_is_numeric?
      current =~ /[0-9]/
    end

    def parenthesis?
      current == "(" || current == ")"
    end

    def current
      @characters[@current]
    end

  end
end
